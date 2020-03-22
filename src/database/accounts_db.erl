-module(accounts_db).

-export([get_account/2, insert_account/2]).

insert_account(Conn, Email) ->
    Uuid = uuid:to_string(uuid:uuid4()),
    Now = calendar:local_time(),
    {ok, _} = pgdb:equery(Conn,
			  "Insert INTO accounts(email, uuid, created_at, "
			  "updated_at) VALUES ($1, $2, $3, $3);",
			  [Email, Uuid, Now]).

get_account(Conn, Uuid) ->
    case pgdb:equery(Conn,
		       "SELECT id, uuid, email, created_at, "
		       "updated_at FROM accounts WHERE uuid=$1",
		       [Uuid])
	of
      {ok, _, [{Id, Uuid, Email, CreatedAt, UpdatedAt}]} ->
	  {ok,
	   #{id => Id, uuid => Uuid, email => Email,
	     created_at => CreatedAt, updated_at => UpdatedAt}};
      Result ->
	  %   logger:warning("~p", [Result]),
	  {error, "User does not exist."}
    end.

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

insert_account_test() ->
    ok = migrate_db:prepare_test_db(),
    {ok, _} = insert_account(default_pool,
			     "ehansen1231@gmail.com").

get_account_test() ->
    ok = migrate_db:prepare_test_db(),
    {ok, _} = get_account(default_pool,
			  "b06c1b51-da53-43ce-ae4d-ac52ba9da938").

-endif.
