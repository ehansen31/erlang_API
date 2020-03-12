%%%-------------------------------------------------------------------
%% @doc erlang_api public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_api_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_',
				       [{"/", hello_handler, []}],
				       [{"/contact", contact_us_handler, []}]}]),
    {ok, _} = cowboy:start_clear(my_http_listener,
				 [{port, 8080}],
				 #{env => #{dispatch => Dispatch}}),
    erlang_api_sup:start_link().

stop(_State) -> ok.

%% internal functions

