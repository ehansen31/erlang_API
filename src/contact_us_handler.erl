-module(contact_us_handler).

-behavior(cowboy_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    {BodyPropList} = jiffy:decode(Data),
    Message = proplists:get_value(<<"message">>,
				  BodyPropList, <<"">>),
    Email = proplists:get_value(<<"message">>, BodyPropList,
				<<"">>),
    Req2 = cowboy_req:reply(200,
			    #{<<"content-type">> => <<"text/plain">>}, Message,
			    Req0),
    {ok, Req2, State};
init(Req0, State) ->
    Req = cowboy_req:reply(405,
			   #{<<"allow">> => <<"POST">>}, Req0),
    {ok, Req, State}.
