-module(fixtures).

-export([inject/0]).

inject() ->
    {ok, _} = pgapp:squery(pgdb,
			   "Insert INTO accounts(email, uuid, created_at, "
			   "updated_at) VALUES ('e.hansen31@live.com','b0"
			   "6c1b51-da53-43ce-ae4d-ac52ba9da938', "
			   "'2020-03-17 21:50:46', '2020-03-17 21:50:46')"
			   ";"),
    ok.
