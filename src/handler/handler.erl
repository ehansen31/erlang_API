-module(handler).

-behaviour(openapi_logic_handler).

-export([handle_request/3]).

-export([authorize_api_key/2]).

-spec authorize_api_key(OperationID ::
			    openapi_api:operation_id(),
			ApiKey :: binary()) -> {true, #{}}.

authorize_api_key(_, ApiKey) ->
    {ok, #{<<"uuid">> := Uuid}} = jwt:decode(ApiKey,
					     <<"key">>),
    {ok, Account} = accounts_db:get_account(Uuid),
    {true, #{account => Account}}.

-spec handle_request(OperationID ::
			 openapi_api:operation_id(),
		     Req :: cowboy_req:req(), Context :: #{}) -> {Status ::
								      cowboy:http_status(),
								  Headers ::
								      cowboy:http_headers(),
								  Body ::
								      jsx:json_term()}.

handle_request('GetAccount', Req,
	       #{account := Account} = Context) ->
    logger:warning("Request object:\n~p", [Req]),
    logger:warning("Context object:\n~p", [Context]),
    {200, #{}, Account};
handle_request(OperationID, Req, Context) ->
    error_logger:error_msg("Got not implemented request to process: "
			   "~p~n",
			   [{OperationID, Req, Context}]),
    {501, #{}, #{}}.

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

authorized_test() ->
    Claims = [{<<"uuid">>,
	       <<"b06c1b51-da53-43ce-ae4d-ac52ba9da938">>}],
    {ok, Token} = jwt:encode(<<"HS256">>, Claims,
			     <<"key">>),
    logger:warning("token is: ~p", [Token]),
    meck:new(accounts_db),
    meck:expect(accounts_db, get_account,
		fun (Uuid) -> {ok, #{id => 1, uuid => Uuid}} end),
    {true, #{account := Result}} =
	authorize_api_key('GetAccount', Token),
    logger:warning("~p", [Result]),
    ?assert((maps:is_key(id, Result))),
    ?assert((meck:validate(accounts_db))),
    meck:unload(accounts_db).

-endif.
