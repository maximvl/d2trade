-module(cboss).

%% API.
-export([start/0]).

start() ->

  %% RuntimeDir = "/var/lib/openshift/51850c265004460e790000a3/app-root/runtime",
  %% true = code:add_patha(RuntimeDir ++ "/cowboy/ebin"),
  %% true = code:add_patha(RuntimeDir ++ "/cowboy/deps/ranch/ebin"),
  
  reloader:start(),
  ok = application:start(crypto),
  ok = application:start(ranch),
  ok = application:start(cowboy),
  ok = application:start(cboss).
