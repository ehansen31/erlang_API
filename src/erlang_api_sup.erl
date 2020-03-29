%%%-------------------------------------------------------------------
%% @doc erlang_api top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(erlang_api_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []),
    Spec = swagger_server:child_spec(api,
				     #{ip => {127, 0, 0, 1}, port => 8080,
				       logic_handler =>
					   swagger_default_logic_handler,
				       net_opts => []}),
    supervisor:start_child(erlang_api_sup, Spec).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all, intensity => 0,
		 period => 1},
    ChildSpecs = [],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions

