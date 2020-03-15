-module(datastore).

-export([insert_contact_us/3, migrate/0]).

migrate() ->
    % Conn = ?config(pgdb, Opts),
    % Conn = pgdb,
    {ok, Conn} = epgsql:connect("localhost", "user", "pass",
				#{database => "erlang_api", timeout => 4000}),
    % ...
    MigrationCall =
	pure_migrations:migrate("migrations/",
				fun (F) ->
					epgsql:with_transaction(Conn,
								fun (_) -> F()
								end)
				end,
				fun (Q) ->
					case epgsql:squery(Conn, Q) of
					  {ok,
					   [{column, <<"version">>, _, _, _, _,
					     _},
					    {column, <<"filename">>, _, _, _, _,
					     _}],
					   Data} ->
					      [{list_to_integer(binary_to_list(BinV)),
						binary_to_list(BinF)}
					       || {BinV, BinF} <- Data];
					  {ok,
					   [{column, <<"max">>, _, _, _, _, _}],
					   [{null}]} ->
					      -1;
					  {ok,
					   [{column, <<"max">>, _, _, _, _, _}],
					   [{N}]} ->
					      list_to_integer(binary_to_list(N));
					  [{ok, _, _}, {ok, _}] -> ok;
					  {ok, _, _} -> ok;
					  {ok, _} -> ok;
					  Default -> Default
					end
				end),
    % ...
    %% more preparation steps if needed
    % ...
    %% migration call
    ok = MigrationCall(),
    ok = epgsql:close(Conn).

prepare_test_db(Pool) -> ok.

insert_contact_us(Pool, Message, Email) ->
    Now = calendar:local_time(),
    % logger:warning("", Now).
    pgapp:equery(Pool,
		 "Insert INTO contacts(email, message,created_a"
		 "t, updated_at) VALUES($1, $2, $3, $3)",
		 [Email, Message, Now]).
