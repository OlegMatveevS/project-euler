-module(test_five).
-author("олег").

%% API
-include_lib("eunit/include/eunit.hrl").

%% test five module
funct_test() ->
  ?assertEqual(232792560, five:tail_recursion_start()),
  ?assertEqual(2520, five:recursion_start()),
  ?assertEqual(2520, five:filter_start()),
  ?assertEqual(2520, five:map_start()).


