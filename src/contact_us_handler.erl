-module(contact_us_handler).

-behavior(cowboy_rest).

-export([init/2]).

-export([allowed_methods/2]).

-export([content_types_accepted/2]).

-export([contact_us/2]).

init(Req, State) -> {cowboy_rest, Req, State}.

content_types_accepted(Req, State) ->
    {[{<<"application/json">>, contact_us}], Req, State}.

allowed_methods(Req, State) ->
    {[<<"POST">>], Req, State}.

contact_us(Req, State) ->
    Req1 = cowboy_req:reply(200,
			    #{<<"content-type">> => <<"text/plaid">>},
			    jiffy:encode(<<"Body">>), Req),
    {ok, Req1,
     State}.    % {ok, Body, Req1} = cowboy_req:read_urlencoded_body(Req),
		% case Body of
		%   [{Input, true}] ->

        %   Req1 = cowboy_req:reply(200,
	% 			  #{<<"content-type">> =>
	% 				<<"application/json">>},
	% 			  jiffy:encode(<<"Body">>), Req),
	%   {ok, Req1, State};
    %   [] ->

        %   Req1 = cowboy_req:reply(400,
	% 			  #{<<"content-type">> =>
	% 				<<"application/json">>},
	% 			  jiffy:encode(<<"Missing body">>), Req);
    %   _ ->

        %   Req1 = cowboy_req:reply(400,
	% 			  #{<<"content-type">> =>
	% 				<<"application/json">>},
	% 			  jiffy:encode(<<"Bad Request">>), Req)
    % end.

