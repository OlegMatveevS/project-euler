-module(test_five).
-author("олег").

%% API
-include_lib("eunit/include/eunit.hrl").

-export([test/0]).


%% test five module
test() ->
  ?assertEqual(232792560, five:tail_recursion_start()),
  ?assertEqual(232792560, five:recursion_start()),
  ?assertEqual(232792560, five:filter_start()),
  ?assertEqual(232792560, five:map_start()).

