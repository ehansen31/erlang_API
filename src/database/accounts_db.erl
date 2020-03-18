-module(accounts_db).

-export([get_account/1, insert_account/1]).

insert_account(Email) ->
    Uuid = uuid:to_string(uuid:uuid4()),
    Now = calendar:local_time(),
    pgapp:equery(pgdb,
		 "Insert INTO accounts(email, uuid, created_at, "
		 "updated_at) VALUES ($1, $2, $3, $3);",
		 [Email, Uuid,
		  Now]).    % logger:warning("result is: ~p", [Result]),

get_account(Uuid) ->
    % {ok, _, [{Id, Email, Fname, Lname}]} -> {ok, #{id => Id, email => Email, fname => Fname, lname => Lname}};
    pgapp:equery(pgdb,
		 "SELECT id, uuid, email, created_at, "
		 "updated_at FROM accounts WHERE uuid=$1",
		 [Uuid]).

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

insert_account_test() ->
    migrate_db:prepare_test_db(),
    {ok, _} = insert_account("ehansen1231@gmail.com").

get_account_test() ->
    migrate_db:prepare_test_db(),
    {ok, _, _} =
	get_account("b06c1b51-da53-43ce-ae4d-ac52ba9da938").

-endif.
