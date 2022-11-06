-module(test_five).
-author("олег").

%% API
-include_lib("eunit/include/eunit.hrl").

%% test five module
first_test() ->
  ?assertEqual(232792560, five:tail_recursion_start()).
second_test() ->
  ?assertEqual(2520, five:recursion_start()).
third_test() ->
  ?assertEqual(2520, five:filter_start()).
four_test() ->
  ?assertEqual(2520, five:map_start()).





