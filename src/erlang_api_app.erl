%%%-------------------------------------------------------------------
%% @doc erlang_api public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_api_app).

-behaviour(application).

-behaviour(supervisor).

-export([start/0, stop/0]).

-export([start/2, stop/1]).

-export([init/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_',
				       [{"/", hello_handler, []},
					{"/contact", contact_us_handler,
					 []}]}]),
    {ok, _} = cowboy:start_clear(my_http_listener,
				 [{port, 8080}],
				 #{env => #{dispatch => Dispatch}}),
    % erlang_api_sup:start_link(),
    supervisor:start_link({local, erlang_api_sup}, ?MODULE,
			  []).

start() -> application:start(?MODULE).

stop() -> application:stop(?MODULE).

stop(_State) -> ok.

%% internal functions

init([]) ->
    {ok, Pools} = application:get_env(erlang_api, pools),
    PoolSpecs = lists:map(fun ({Name, SizeArgs,
				WorkerArgs}) ->
				  PoolArgs = [{name, {local, Name}},
					      {worker_module,
					       erlang_api_worker}]
					       ++ SizeArgs,
				  poolboy:child_spec(Name, PoolArgs, WorkerArgs)
			  end,
			  Pools),
    {ok, {{one_for_one, 10, 10}, PoolSpecs}}.
