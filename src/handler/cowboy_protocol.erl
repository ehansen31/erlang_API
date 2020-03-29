-module(cowboy_protocol).

-behaviour(ranch_protocol).

-export([start_link/4]).

-export([init/4]).

start_link(Ref, Socket, Transport, Opts) ->
    Pid = spawn_link(?MODULE, init,
		     [Ref, Socket, Transport, Opts]),
    {ok, Pid}.

init(Ref, Socket, Transport, _Opts) ->
    ok = ranch:accept_ack(Ref), loop(Socket, Transport).

loop(Socket, Transport) ->
    case Transport:recv(Socket, 0, 5000) of
      {ok, Data} ->
	  io:format("data:\n~p", [Data]),
	  Transport:send(Socket, Data),
	  loop(Socket, Transport);
      _ -> ok = Transport:close(Socket)
    end.

% -export([init/4, start_link/4]).

% start_link(ListenerPid, Socket, Transport, Opts) ->
%     Pid = spawn_link(?MODULE, init,
% 		     [ListenerPid, Socket, Transport, Opts]),
%     {ok, Pid}.

% init(ListenerPid, Socket, Transport, Opts) ->
%     [{env, [{dispatch, Dispatch}]}] = Opts,
%     % cowboy:start_tls(ListenerPid,
%     % 	     #{socket_opts => Socket, transport_opts => Transport},
%     % 	     #{env => #{dispatch => Dispatch}}),
%     cowboy:start_clear(cowboy_api_now,
% 		          #{socket_opts => Socket, transport_opts => Transport},
% 		    %    [{port, 8080}, {ip, {127, 0, 0, 1}}],
% 		       #{env => #{dispatch => Dispatch}}),
%     ok.

