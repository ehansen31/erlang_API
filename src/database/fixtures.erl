-module(fixtures).

-export([inject/1]).

inject(Conn) ->
    Worker = poolboy:checkout(default_pool),
    erlang_api_app:squery(Worker,
			  "Insert INTO accounts(email, uuid,created_at, "
			  "updated_at) VALUES ('e.hansen31@live.com','b0"
			  "6c1b51-da53-43ce-ae4d-ac52ba9da938', "
			  "'2020-03-17 21:50:46', '2020-03-17 21:50:46')"
			  ";"),
    poolboy:checkin(default_pool, Worker),
    % {ok, _} = epgsql:squery(Conn,
    % 		   "Insert INTO accounts(email, uuid,created_"
    % 		   "at, updated_at) VALUES ('e.hansen31@live.c"
    % 		   "om','b06c1b51-da53-43ce-ae4d-ac52ba9da938', "
    % 		   "'2020-03-17 21:50:46', '2020-03-17 21:50:46')"
    % 		   ";"),
    ok.
