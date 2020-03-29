%%%-------------------------------------------------------------------
%% @doc erlang_api public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_api_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    openapi_server:start(http_server,
			 #{ip => {127, 0, 0, 1}, port => 8080, net_opts => [],
			   logic_handler => handler}),
    erlang_api_sup:start_link().

stop(_State) -> ok.
