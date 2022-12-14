-module(test_five).


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
five_test() ->
  ?assertEqual(2520, five:endless_list_start()).



