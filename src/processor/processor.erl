-module(processor).

-export([start/0]).

start() ->
    spawn(process_webhook_prcsr, process, []),
    ok.
