-module(accounts_db).

-export([get_account/1, insert_account/1]).

insert_account(Email) ->
    Uuid = uuid:to_string(uuid:uuid4()),
    Now = calendar:local_time(),
    pgapp:equery(pgdb,
		 "Insert INTO accounts(email, uuid,created_at, "
		 "updated_at) VALUES ($1, $2, $3, $3);",
		 [Email, Uuid,
		  Now]).    % logger:warning("result is: ~p", [Result]),

get_account(Uuid) ->
    pgapp:equery(pgdb,
		 "SELECT id, uuid, email, created_at, "
		 "updated_at FROM accounts WHERE uuid=$1",
		 [Uuid]).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

insert_account_test() ->
    {ok, _} = insert_account("e.hansen31@live.com").

-endif.
