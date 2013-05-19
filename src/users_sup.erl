%%%-------------------------------------------------------------------
%%% File    : users_sup.erl
%%% Author  : OpenShift guest <51850c265004460e790000a3@ex-std-node160.prod.rhcloud.com>
%%% Description : 
%%%
%%% Created : 19 May 2013 by OpenShift guest <51850c265004460e790000a3@ex-std-node160.prod.rhcloud.com>
%%%-------------------------------------------------------------------
-module(users_sup).

-behaviour(supervisor).
%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
         start_link/0,
         new_user/0,
         remove_user/1
        ]).

%%--------------------------------------------------------------------
%% Internal exports
%%--------------------------------------------------------------------
-export([
         init/1
        ]).

%%--------------------------------------------------------------------
%% Macros
%%--------------------------------------------------------------------
-define(SERVER, ?MODULE).

%%--------------------------------------------------------------------
%% Records
%%--------------------------------------------------------------------

%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link/0
%% Description: Starts the supervisor
%%--------------------------------------------------------------------
start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

new_user() ->
  supervisor:start_child(?SERVER, [self()]).

remove_user(Pid) ->
  supervisor:terminate_child(?SERVER, Pid).

%%====================================================================
%% Server functions
%%====================================================================
%%--------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}   
%%--------------------------------------------------------------------
init([]) ->
  AChild = {'user_srv',{'user_srv',start_link,[]},
            transient,2000,worker,['user_srv']},
  {ok,{{simple_one_for_one,1,1}, [AChild]}}.

%%====================================================================
%% Internal functions
%%====================================================================