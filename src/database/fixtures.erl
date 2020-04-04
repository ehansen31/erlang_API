-module(fixtures).

-export([inject/0]).

inject() ->
    {ok, _} = pgapp:squery(pgdb,
			   "Insert INTO accounts(email, uuid, url, "
			   "created_at, updated_at) VALUES ('e.hansen31@l"
			   "ive.com','b06c1b51-da53-43ce-ae4d-ac52ba9da93"
			   "8', '127.0.0.1:8080', '2020-03-17 21:50:46', "
			   "'2020-03-17 21:50:46');"),
    ok.
