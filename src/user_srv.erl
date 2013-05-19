-module(user_srv).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {websock, nick}).
-define(SERVER, ?MODULE).

start_link(Args) ->
  gen_server:start_link(?MODULE, Args, []).

init(WSock) ->
  Nick = list_to_binary(pid_to_list(self())),
  {ok, #state{websock=WSock, nick=Nick}}.

handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_cast({send_msg, Text}, State) ->
  [ gen_server:cast(Pid, {msg, State#state.nick, Text}) 
    ||  {_, Pid, _, _} <- supervisor:which_children('users_sup') ],
  {noreply, State};

handle_cast({set_nick, Nick}, State) ->
  {noreply, State#state{nick=Nick}};

handle_cast({msg, _From, _Text}=Msg, State) ->
  WebSock = State#state.websock,
  WebSock ! Msg,
  {noreply, State};

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  io:format("got info: ~w~n", [_Info]),
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("user: ~w terminated~n", [self()]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
