-module(mq).

-export([init/0]).

-include("_build/default/lib/amqp_client/include/amqp_c"
	 "lient.hrl").

init() ->
    {ok, Connection} =
	amqp_connection:start(#amqp_params_network{}),
    register(mq_conn, Connection),
    {ok, Channel} = amqp_connection:open_channel(mq_conn),
    %% Create a queue for our webhook topic
    DeclareExchange = #'exchange.declare'{exchange =
					      <<"webhook_exchange">>,
					  type = <<"topic">>},
    #'exchange.declare_ok'{} = amqp_channel:call(Channel,
						 DeclareExchange),
    DeclareQueue = #'queue.declare'{queue =
					<<"webhook_queue">>},
    #'queue.declare_ok'{queue = Q} =
	amqp_channel:call(Channel, DeclareQueue),
    Binding = #'queue.bind'{queue = Q,
			    exchange = <<"webhook_exchange">>,
			    routing_key = <<"endpoint">>},
    #'queue.bind_ok'{} = amqp_channel:call(Channel,
					   Binding),
    amqp_channel:close(Channel),
    ok.
