-module(fixtures).

-export([inject/0]).

inject() ->
    {ok, _} = pgapp:squery(pgdb,
			   "Insert INTO accounts(id, email, uuid,created_"
			   "at, updated_at) VALUES (1, 'e.hansen31@live.c"
			   "om','b06c1b51-da53-43ce-ae4d-ac52ba9da938', "
			   "'2020-03-17 21:50:46', '2020-03-17 21:50:46')"
			   ";"),
    ok.