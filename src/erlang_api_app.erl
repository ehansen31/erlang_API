%%%-------------------------------------------------------------------
%% @doc erlang_api public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_api_app).

-behaviour(application).

-export([init/1, start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_',
				       [{"/", hello_handler, []},
					{"/contact", contact_us_handler,
					 []}]}]),
    {ok, _} = cowboy:start_clear(my_http_listener,
				 [{port, 8080}],
				 #{env => #{dispatch => Dispatch}}),
    erlang_api_sup:start_link().

stop(_State) -> ok.

%% internal functions

init([]) ->
    {ok, Pools} = application:get_env(example, pools),
    PoolSpecs = lists:map(fun ({Name, SizeArgs,
				WorkerArgs}) ->
				  PoolArgs = [{name, {local, Name}},
					      {worker_module, example_worker}]
					       ++ SizeArgs,
				  poolboy:child_spec(Name, PoolArgs, WorkerArgs)
			  end,
			  Pools),
    {ok, {{one_for_one, 10, 10}, PoolSpecs}}.
