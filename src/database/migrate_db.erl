-module(migrate_db).

-export([migrate/0]).

migrate() ->
    {ok, Conn} = epgsql:connect("localhost", "user", "pass",
				#{database => "erlang_api", timeout => 4000}),
    MigrationCall =
	pure_migrations:migrate("src/database/migrations",
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
    ok = MigrationCall(),
    ok = epgsql:close(Conn).

prepare_test_db() -> ok.