-module(middleware).

-export([authorized/1]).

authorized(Req) ->
    Auth = cowboy_req:header(<<"authorization">>, Req, nil),
    {ok, [{<<"uuid">>, Uuid}]} = jwt:decode(Auth,
					    <<"key">>),
    accounts_db:get_account(Uuid),
    % place account in response
    {true, Req}.

% meck on db call for testing...

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

authorized_test() -> 
    jwt:encode(),
authorized(#{<<"authorization">>=> ""}), ok.

-endif.
