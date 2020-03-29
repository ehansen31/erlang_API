-module(cowboy_protocol).

-export([init/4, start_link/4]).

start_link(ListenerPid, Socket, Transport, Opts) ->
    Pid = spawn_link(?MODULE, init,
		     [ListenerPid, Socket, Transport, Opts]),
    {ok, Pid}.

init(ListenerPid, Socket, Transport, Opts) ->
    [{env, [{dispatch, Dispatch}]}] = Opts,
    cowboy:start_tls(ListenerPid,
		     #{socket_opts => Socket, transport_opts => Transport},
		     #{env => #{dispatch => Dispatch}}),
    ok.
