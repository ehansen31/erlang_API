-module(publish_webhook_svc).

-export([publish/2]).

-include("_build/default/lib/amqp_client/include/amqp_c"
	 "lient.hrl").

publish(URL, Message) ->
    %% Open a channel on the connection
    {ok, Channel} =
	amqp_connection:open_channel(mq_conn),
    %% Publish a message
    PayloadMap = #{<<"message">> => list_to_binary(Message),
		   <<"url">> => list_to_binary(URL)},
    Payload = jsx:encode(PayloadMap),
    Publish = #'basic.publish'{exchange =
				   <<"webhook_exchange">>,
			       routing_key = <<"endpoint">>},
    amqp_channel:cast(Channel, Publish,
		      #amqp_msg{payload = Payload}),
    %% Close the channel
    amqp_channel:close(Channel),
    ok.
