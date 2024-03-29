-module(endless_list).


%% API
-export([create/2, internal_loop/2, next/1, filter_next/2, delete/1]).

create(Func, Start) ->
  spawn(endless_list, internal_loop, [Func, Start]).

internal_loop(Func, Next) ->
  receive
    {Pid, take_next, Next} ->
      Pid ! Next,
      NewNext = Next,
      internal_loop(Func, NewNext);
    close -> closed
  end.

next(ListIter) ->
  ListIter ! {self(), take_next},
  receive
    Next -> Next
  after 10000 -> exit(timeout)
  end.

filter_next(ListIter, FilterFunc) ->
  case next(ListIter) of
    Next when Next == error -> error;
    Next when Next =/= error ->
      case FilterFunc(Next) of
        true -> Next;
        _ -> filter_next(ListIter, FilterFunc)
      end
  end.

delete(ListIter) ->
  ListIter ! finished.
