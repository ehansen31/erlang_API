%%%-------------------------------------------------------------------
%% @doc erlang_api public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_api_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    % Result = swagger_server:child_spec(api,
	% 			       #{ip => {127, 0, 0, 1}, port => 8080,
	% 				 logic_handler =>
	% 				     swagger_default_logic_handler,
	% 				 net_opts => []}),
    % logger:warning("Result is \n~p", [Result]),
	% supervisor:start_child(erlang_api_sup, Result),
	% ranch:start_listener(Result),
    erlang_api_sup:start_link().

stop(_State) -> ok.
