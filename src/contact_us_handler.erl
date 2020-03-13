-module(contact_us_handler).

-behavior(cowboy_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    % logger:error("error happened because: ~p", Data),
    % BodyMap = jiffy:decode(Data),
    Req2 = cowboy_req:reply(200,
			    #{<<"content-type">> => <<"text/plain">>}, Data,
			    Req0),
    {ok, Req2, State};
init(Req0, State) ->
    Req = cowboy_req:reply(405,
			   #{<<"allow">> => <<"POST">>}, Req0),
    {ok, Req, State}.
