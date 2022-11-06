-module(five).
-author("oleg").

%% API
-export([
  tail_recursion_start/0,
  recursion_start/0,
  filter_start/0,
  map_start/0
  , endless_list_start/0]).

-export([]).

%% Common code %%
is_divided_result(0) -> true;
is_divided_result(_) -> false.

is_divided_without_rem_on_seq(Number, Start, Finish) ->
  is_divided_result(length([X || X <- lists:seq(Start, Finish), Number rem X =/= 0])).


%% Tail recursion implementation return result %%


tail_recursion_start() ->
  tail_recursion(232792559, 300000000).

tail_recursion(Start, Finish) ->
  tail_recursion(Start, Finish, 0).

tail_recursion(Start, Finish, Acc) ->
  case is_divided_without_rem_on_seq(Start, 2, 20) of
    true -> Start + 0;
    false -> tail_recursion(Start + 1, Finish, Acc)
  end.


%% recursion implementation return result in value
recursion_start() -> recursion(1) + 0.

recursion(3000) -> 0;

recursion(Number) ->
  case recursion(Number + 1) of
    Result when Result == 0 ->
      case is_divided_without_rem_on_seq(Number, 1, 10) of
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
      Y <- [X || X <- lists:seq(1, 3000), X rem 2 == 0],
      is_divided_without_rem_on_seq(Y, 1, 10) == true]).

%% Map implementation %%

map_start() ->
  map(1).

check_item(true, Item) -> Item;

check_item(_, _) -> 0.

map(Start) ->
  lists:nth(
    1,
    [X ||
      X <- lists:map(
        fun(Item) ->
          check_item(is_divided_without_rem_on_seq(Item, 1, 10), Item)
        end,
        lists:seq(Start, 3000)
      ),
      X =/= 0
    ]
  ).

%% Endless list implementation %%

endless_list_start() ->
  ListIter = endless_list:create(fun(X) -> X + 1 end, 1),
  endless_list_find_solution(ListIter, 1).

endless_list_find_solution(_, 300000000) -> 0;

endless_list_find_solution(Iter, Count) ->
  Value = endless_list:next(Iter),
  case Value of
    error -> exit("Endless list timed out!");
    _ ->
      case is_divided_without_rem_on_seq(Value, 1, 10) of
        true -> Value;
        _ -> endless_list_find_solution(Iter, Count + 1)
      end
  end.

