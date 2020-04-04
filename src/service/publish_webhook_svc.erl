-module(publish_webhook_svc).

-export([publish/2]).

-include("_build/default/lib/amqp_client/include/amqp_c"
	 "lient.hrl").

publish(URL, Message) ->
    %% Start a network connection
    {ok, Connection} =
	amqp_connection:start(#amqp_params_network{}),
    %% Open a channel on the connection
    {ok, Channel} =
	amqp_connection:open_channel(Connection),
    %% Create a queue for our webhook topic

    DeclareExchange = #'exchange.declare'{exchange =
				      <<"webhook_exchange">>, type = <<"topic">>},
    #'exchange.declare_ok'{} = amqp_channel:call(Channel,
						 DeclareExchange),

    DeclareQueue = #'queue.declare'{queue = <<"webhook_queue">>},
    #'queue.declare_ok'{queue = Q} = amqp_channel:call(Channel,
					      DeclareQueue),

    Binding = #'queue.bind'{queue       = Q,
                            exchange    = <<"webhook_exchange">>,
                            routing_key = <<"endpoint">>},

    #'queue.bind_ok'{} = amqp_channel:call(Channel, Binding),


                    
    %% Publish a message
    PayloadMap = #{<<"message">>=><<Message>>, <<"url">>=><<URL>>},
    % encode json into binary here
    Payload = jsx:encode(PayloadMap),


    Publish = #'basic.publish'{exchange = <<"webhook_exchange">>,
			       routing_key = <<"endpoint">>},
    amqp_channel:cast(Channel, Publish,
		      #amqp_msg{payload = Payload}),
    %% Close the channel
    amqp_channel:close(Channel),
    %% Close the connection
    amqp_connection:close(Connection),
    ok.
