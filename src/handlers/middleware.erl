-module(middleware).

-export([authorized/1]).

authorized(Req) ->
    {ok, Auth} = cowboy_req:header(<<"Authorization">>, Req,
				   nil),
    {ok, #{<<"uuid">> := Uuid}} = jwt:decode(Auth,
					     <<"key">>),
    % get pool here...
    Account = accounts_db:get_account(Uuid),
    logger:warning("~p", [Account]),
    % place account in response
    {true, Req}.

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

authorized_test() ->
    Claims = [{<<"uuid">>,
	       <<"779401e8-61d8-4630-aec7-37ca550f6e76">>}],
    Token = jwt:encode(<<"HS256">>, Claims, <<"key">>),
    authorized(#{headers =>
		     #{<<"Authorization">> => Token}}),
    meck:new(accounts_db),
    meck:expect(accounts_db, get_account,
		fun (Uuid) -> Uuid end),
    ?assert((meck:validate(accounts_db))),
    meck:unload(accounts_db).

-endif.
