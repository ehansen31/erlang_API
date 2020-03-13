-module(contact_us_handler).

-behavior(cowboy_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
    Req = cowboy_req:reply(200,
			   #{<<"content-type">> => <<"text/plain">>},
			   <<"Hello world!">>, Req0),
    {ok, Req, State};
init(Req0, State) ->
    Req = cowboy_req:reply(405,
			   #{<<"allow">> => <<"POST">>}, Req0),
    {ok, Req, State}.
