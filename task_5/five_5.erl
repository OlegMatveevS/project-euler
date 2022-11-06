-module(five).
-author("oleg").

%% API
-export([
  tail_recursion_start/0,
  recursion_start/0,
  filter_start/0,
  map_start/0
]).

-export([]).

%% Common code %%

is_divided_result(0) -> true;
is_divided_result(_) -> false.

is_divided_without_rem_on_seq(Number, Start, Finish) ->
  is_divided_result(length([X || X <- lists:seq(Start, Finish), Number rem X =/= 0])).


%% Tail recursion implementation return result %%
tail_recursion_start() ->
  tail_recursion(100, 300000000).

tail_recursion(Start, Finish) ->
  tail_recursion(Start, Finish, 0).

tail_recursion(Start, Finish, Acc) ->
  case is_divided_without_rem_on_seq(Start, 1, 20) of
    true -> Start;
    false -> tail_recursion(Start + 1, Finish, Acc)
  end.


%% recursion implementation return result
recursion_start() ->
  recursion(1).

recursion(300000000) -> 0;

recursion(Number) ->
  case recursion(Number + 1) of
    Result when Result == 0 ->
      case is_divided_without_rem_on_seq(Number, 2, 20) of
        true -> Number;
        false -> Result
      end;
    Result when Result =/= 0 -> Result
  end.

%% Filter implementation return result %%
filter_start() ->
  lists:nth(
    1,
    [Y ||
      Y <- [X || X <- lists:seq(1, 300000000), X rem 2 == 0],
      is_divided_without_rem_on_seq(Y, 3, 20) == true]).

%% Map implementation %%

map_start() ->
  map(2).

check_item(true, Item) -> Item;

check_item(_, _) -> 0.

map(Start) ->
  lists:nth(
    1,
    [X ||
      X <- lists:map(
        fun(Item) ->
          check_item(is_divided_without_rem_on_seq(Item, 2, 20), Item)
        end,
        lists:seq(Start, 300000000)
      ),
      X =/= 0
    ]
  ).

