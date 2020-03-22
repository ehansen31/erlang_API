-module(migrate_db).

-export([migrate/0, prepare_test_db/0]).

migrate() ->
    Conn = default_pool,
    MigrationCall =
	pure_migrations:migrate("src/database/migrations",
				fun (F) ->
					pgdb:with_transaction(Conn,
							      fun (_) -> F()
							      end)
				end,
				fun (Q) ->
					case pgdb:squery(Conn, Q) of
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
    ok = MigrationCall().

    % ok = epgsql:close(Conn).

prepare_test_db() ->
    % erlang_api_app:init([]),
    pgdb:squery(default_pool,
		"DROP SCHEMA public CASCADE;"),
    pgdb:squery(default_pool, "create schema public;"),
    Result = migrate(),
    logger:warning("migrate result: ~p", [Result]),
    ok = fixtures:inject(default_pool).
