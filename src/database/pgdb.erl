-module(pgdb).

-export([equery/3, squery/2, with_transaction/2]).

squery(PoolName, Sql) ->
    poolboy:transaction(PoolName,
			fun (Worker) -> gen_server:call(Worker, {squery, Sql})
			end).

equery(PoolName, Stmt, Params) ->
    poolboy:transaction(PoolName,
			fun (Worker) ->
				gen_server:call(Worker, {equery, Stmt, Params})
			end).

with_transaction(PoolName, Fn) ->
    poolboy:transaction(PoolName,
			fun (Worker) ->
				gen_server:call(Worker, {with_transaction, Fn})
			end).
