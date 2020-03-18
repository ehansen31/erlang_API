-module(accounts_db).

-export([get_account/1, insert_account/1]).

insert_account(Email) ->
    Uuid = uuid:to_string(uuid:uuid4()),
    Now = calendar:local_time(),
    pgapp:equery(pgdb,
		 "Insert INTO accounts(email, uuid, created_at, "
		 "updated_at) VALUES ($1, $2, $3, $3);",
		 [Email, Uuid, Now]).

get_account(Uuid) ->
    case pgapp:equery(pgdb,
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
    migrate_db:prepare_test_db(),
    {ok, _} = insert_account("ehansen1231@gmail.com").

get_account_test() ->
    migrate_db:prepare_test_db(),
    Result =
	get_account("b06c1b51-da53-43ce-ae4d-ac52ba9da938"),
    logger:warning("~p", [Result]).

-endif.
