-module(test_period).


%% API
-include_lib("eunit/include/eunit.hrl").

%% test five module
first_test() ->
  ?assertEqual(983, period:tail_recursion_start()).
second_test() ->
  ?assertEqual(983, period:recursion_start()).
third_test() ->
  ?assertEqual(983, period:fold_start()).
four_test() ->
  ?assertEqual(983, period:map_start()).
five_test() ->
  ?assertEqual(983, period:endless_list_start()).




