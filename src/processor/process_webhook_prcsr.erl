-module(process_webhook_prcsr).

-export([process/0]).

-include("_build/default/lib/amqp_client/include/amqp_c"
	 "lient.hrl").

process() ->
    %% Open a channel on the connection
    {ok, Channel} = amqp_connection:open_channel(mq_conn),
    Sub = #'basic.consume'{queue = <<"webhook_queue">>},
    #'basic.consume_ok'{consumer_tag = Tag} =
	amqp_channel:call(Channel, Sub),
    % spawn
    loop(Channel),
    %% Close the channel
    amqp_channel:close(Channel),
    ok.

loop(Channel) ->
    receive
      %% This is the first message received
      #'basic.consume_ok'{} -> loop(Channel);
      %% This is received when the subscription is cancelled
      #'basic.cancel_ok'{} -> ok;
      %% A delivery
      {#'basic.deliver'{delivery_tag = Tag}, Content} ->
	  %% Do something with the message payload
	  %% (some work here)
	  {_, _, BinaryMsg} = Content,
	  Json = jsx:decode(BinaryMsg),
	  %% Ack the message
	  amqp_channel:cast(Channel,
			    #'basic.ack'{delivery_tag = Tag}),
	  %% Loop
	  loop(Channel)
    end.
