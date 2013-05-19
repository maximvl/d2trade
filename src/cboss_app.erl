-module(cboss_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->

  cboss_sup:start_link(),

  DNS = os:getenv("OPENSHIFT_APP_DNS"),
  WsPort = "8000",
  WsAddr = list_to_binary("ws://" ++ DNS ++ ":" ++ WsPort ++ "/websock"),
  
  Dispatch = cowboy_router:compile(
               [
                %% {URIHost, list({URIPath, Handler, Opts})}
                {'_', [
                       {"/",            main_handler, []},
                       {"/websock_req", main_handler, ["websock_req", WsAddr]},
                       {"/websock",     ws_handler,   []},
                       {"/static/[...]", cowboy_static, 
                        [{directory, {priv_dir, cboss, [<<"static">>]}},
                         {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
                        ]}
                      ]}
               ]),
  
  Port = erlang:list_to_integer(
           os:getenv("OPENSHIFT_INTERNAL_PORT")),
  
  {ok, Host} = inet_parse:address(os:getenv("OPENSHIFT_INTERNAL_IP")),
  
  io:format("listening on: ~w:~w~n", [Host, Port]),
  
  cowboy:start_http(
    http,
    100,
    [{port, Port}, {ip, Host}],
    [{env, [{dispatch, Dispatch}]}]).

stop(_State) ->
  cowboy:stop_listener(http),
  ok.
