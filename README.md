# project-euler
Министерство науки и высшего образования Российской Федерации федеральное государственное автономное образовательное учреждение высшего образования

«Национальный исследовательский университет ИТМО»

---
__ФПИиКТ, Системное и Прикладное Программное Обеспечение__

__Лабораторная работа №1__

по Функциональному программированию

Выполнил: Матвеев О.И.

Группа: P34112

Преподаватель: Пенской Александр Владимирович

###### Санкт-Петербург
###### 2022 г.
---

## Описание проблемы
### [Smallest multiple](https://projecteuler.net/problem=5)

#### Problem 5

2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

### [Distinct powers](https://projecteuler.net/problem=26)

#### Problem 26

A unit fraction contains 1 in the numerator. The decimal representation of the unit fractions with denominators 2 to 10 are given:

$$
  \begin{align}
  1/2	= 	 0.5\\
  1/3	= 	 0.(3)\\
  1/4	= 	 0.25\\
  1/5	= 	 0.2\\
  1/6	= 	 0.1(6)\\
  1/7	= 	 0.(142857)\\
  1/8	= 	 0.125\\
  1/9	= 	 0.(1)\\
  1/10= 	 0.1
\end{align}
$$

Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can be seen that 1/7 has a 6-digit recurring cycle.

Find the value of d < 1000 for which 1/d contains the longest recurring cycle in its decimal fraction part.

## Ключевые элементы реализации с минимальными комментариями

### Problem 5

1. __монолитная реализация__
    + __хвостовая рекурсия__
    ```
    is_divided_without_rem_on_seq(Number, Start, Finish) ->
      is_divided_result(length([X || X <- lists:seq(Start, Finish), Number rem X =/= 0])).
    
    tail_recursion_start() -> tail_recursion(1, false).

    tail_recursion(?PROPERTY_MAX_COUNTER, _) -> print_answer(0);

    tail_recursion(Number, true) -> print_answer(Number - 1);

    tail_recursion(Number, false) -> tail_recursion(Number + 1, is_divided_without_rem_on_seq(Number, 2, 20)).
    
    ```
    Вспомогательная функция проверяет делимость числа, в случае успеха выводится число, иначе рекурсивно вызвать фунцию и продолжить проверять (предыдующее + 1) число.
    
    
    + __рекурсия__
    ```
    recursion_start() -> print_answer(recursion(1)).

    recursion(?PROPERTY_MAX_COUNTER) -> 0;

    recursion(Number) ->
      case recursion(Number + 1) of
        Result when Result == 0 ->
          case is_divided_without_rem_on_seq(Number, 2, 20) of
            true -> Number;
            false -> Result
          end;
        Result when Result =/= 0 -> Result
      end.
    ```
    Также проверять всопомогательной функцией пока не найден результат.
    
2. __Filter реализация__
    ```
    filter_start() ->
      print_answer(
        lists:nth(
          1,
          [Y ||
            Y <- [X || X <- lists:seq(1, ?PROPERTY_MAX_COUNTER), X rem 2 == 0],
            is_divided_without_rem_on_seq(Y, 3, 20) == true])).
     ```
     Генерируем сначала только четные числа(т.к есть условии делимости на них), далее только те, что удовлетворяют условию функции
     
3. __Map реализация__
    ```
    map_start() ->
      print_answer(map(2)).

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
            lists:seq(Start, ?PROPERTY_MAX_COUNTER)
          ),
          X =/= 0
        ]
      ).
      ```
      В список попадают только те числа, что удовлетворяют условию функции map, на вход map передаем искомый диапазон

4. __работа с бесконечными списками для языков поддерживающих ленивые коллекции или итераторы как часть языка__
    ```
    endless_list_start() ->
     ListIter = endless_list:create(fun(X) -> X + 1 end, 1),
      endless_list_find_solution(ListIter, 1).

    endless_list_find_solution(_, ?PROPERTY_MAX_COUNTER) -> 0;

    endless_list_find_solution(Iter, Count) ->
      Value = endless_list:next(Iter),
      case Value of
       error -> exit("Endless list timed out!");
        _ ->
          case is_divided_without_rem_on_seq(Value, 1, 20) of
           true -> Value;
            _ -> endless_list_find_solution(Iter, Count + 1)
          end
     end.
     ```
     Проверяем число с помощью всопомгательной функции, если нет, то вызываем следующую итерацию с большим числом.

5. __реализация на любом удобном языке программировании__
    ```
    #include <iostream>

    int main()
    {
        for (int i = 100; i < 1000000000; i++)
        {
            bool result = true;
            for (int j = 1; j <= 20; j++)
            {
                if (i % j != 0)
                {
                    result = false;
                    break;
                }
            }

            if (result)
            {
                std::cout << "Result: " << i << std::endl;
                break;
            }
        }
        return 0;
    }
    ```
    Простая проверка в цикле каждого числа на делимость от 1 до 20.
    
### Problem 26

1. __Хвостовая рекурсия__
   ```
   tail_recursion_start() ->
     tail_recursion(1, 0).

    tail_recursion(?PROPERTY_MAX_COUNTER, Max) ->
      Max;

    tail_recursion(Number, Max) ->
     case string:length(period_generator(Number, 0, "", 1, maps:new())) of PeriodLen
        when PeriodLen > Max -> tail_recursion(Number + 1, PeriodLen);
       _ -> tail_recursion(Number + 1, Max)
      end.

    period_generator(N, Position, Period, Rem, FirstPos) ->
     case maps:get(Rem, FirstPos, none) of
       none ->
          period_generator(
            N,
            Position + 1,
            Period ++ integer_to_list(Rem div N),
            (Rem rem N) * 10,
            maps:put(Rem, Position, FirstPos));
       _ -> Period
     end.
     ```
     Проверяем длину полученного периода с помощью вспомогательной функции генерации периода, в случае если длинее предыдущего максимума, то рекурсивный вызов с новым max иначе вызов со старым max
     
2. __Рекурсия__
   ```
   recursion_start() ->
     recursion(1, 0).

    recursion(?PROPERTY_MAX_COUNTER, Max) ->
     Max;

    recursion(Number, Max) ->
     NewMax = recursion(Number + 1, Max),
      case string:length(period_generator(Number, 0, "", 1, maps:new())) of PeriodLen
       when PeriodLen > NewMax -> PeriodLen;
        _ -> NewMax
      end.
    ```
    Простая рекурсивная проверка с использованием вспомогательной функции генерации периода 
     
3. __Fold implementation__
   ```
   get_prime_list(Max) -> [X || X <- lists:seq(2, Max), is_prime(X)].

    period_fold(N, PrimeList) ->
     lists:foldl(
       fun(_, MDigits) ->
         NewM = (lists:nth(1, MDigits) + 1) * 10 - 1,
         NewList = [X || X <- MDigits, NewM rem X =/= 0],
         [NewM | NewList -- [lists:nth(1, MDigits)]]
        end,
       [0 | PrimeList],
       lists:seq(2, N)
     ).

    fold_start() ->
     lists:last(period_fold(981, get_prime_list(1001))).
     ```
     В данном решении используется то, что если период числа домножить на 10^(длина периода) и умножить на делитель, то полуится число вида 999999*
     т.е те наборы 99999* что делятся без остатка на число вероятно являются его периодом. В данном решении перый элемент увеличивается в длину на 9 каждый   вызов, после чего все элементы списка(только простые числа) проверяются на остаток, те у кого он отстутвуют остаются в аккумуляторе
     https://www.xarg.org/puzzle/project-euler/problem-26/
     
4. __Map implementation__
   ```
   map_start() -> map().

    map() -> element(2, map(1, get_prime_list(990), 0, 0)).

    map(?PROPERTY_MAX_COUNTER, List, Max, _M) -> {List, Max + 1};

    map(Counter, List, Max, M) ->
      NewM = M * 10 + 9,
      ListAndMax = lists:mapfoldl(
        fun(Item, Test) ->
          case Item =/= 0 of
           Result when Result == true, NewM rem Item == 0 ->
              case Counter > Test of
                true -> {0, Counter};
                _ -> {0, Test}
              end;
            _ -> {Item, Max}
          end
       end,
        Max,
        List
     ),
      map(Counter + 1, element(1, ListAndMax), element(2, ListAndMax), NewM).
     ```
     Данее решение аналогично предыдущему и адаптированно под map.

    ```
    is_prime(Number) ->
      case Number of Number
        when Number =< 2 -> Number == 2;
       _ ->
          case Number rem 2 =/= 0 of
            true ->
             lists:all(
                fun(Item) ->
                 Number rem Item =/= 0
               end,
                [X || X <- lists:seq(3, round(math:sqrt(Number))), X rem 2 =/= 0]
              );
            _ -> false
         end
      end.
      ```
      Функция для нахождения простых чисел(как вариант можно заменить готовым списком)
 
 5. __работа с бесконечными списками для языков поддерживающих ленивые коллекции или итераторы как часть языка__
    ```
    endless_list_start() -> endless_list_find_solution(1, 0, 0, maps:new()).

    fill_map_loop(ListIter, Counter, M, Max, UsedPrimes) ->
      case endless_list:filter_next(ListIter, fun is_prime/1) of
       Error when Error == error -> exit("Endless list generator timed out!");
        NextPrime when NextPrime > 997 -> {Max, UsedPrimes};
       NextPrime when NextPrime =< 997 ->
         MaxUsedPrimesTuple = fill_map(NextPrime, Counter, M, Max, UsedPrimes),
         fill_map_loop(ListIter, Counter, M, element(1, MaxUsedPrimesTuple), element(2, MaxUsedPrimesTuple))
     end.

    fill_map(NextPrime, Counter, M, Max, UsedPrimes) ->
     case maps:get(NextPrime, UsedPrimes, none) == none of IsNotInUsedPrimes
        when IsNotInUsedPrimes == true, M rem NextPrime == 0 ->
        NewUsedPrimes = maps:put(NextPrime, NextPrime, UsedPrimes),
       case Counter > Max of
          true -> {NextPrime, NewUsedPrimes};
          _ -> {Max, NewUsedPrimes}
        end;
        _ -> {Max, UsedPrimes}
      end.

    endless_list_find_solution(?PROPERTY_MAX_COUNTER, _, Max, _) -> Max;

    endless_list_find_solution(Counter, M, Max, UsedPrimes) ->
     NewM = M * 10 + 9,
     ListIter = endless_list:create(fun(X) -> X + 1 end, 2),
     MaxUsedPrimesTuple = fill_map_loop(ListIter, Counter, NewM, Max, UsedPrimes),
     endless_list:delete(ListIter),
     endless_list_find_solution(Counter + 1, NewM, element(1, MaxUsedPrimesTuple), element(2, MaxUsedPrimesTuple)).
     ```
     Проверка аналогична решению с map(используется та же проверка периода с помощью девяток)
     
 6. __реализация на любом удобном языке программировании__
    ```
    #include <iostream>
    #include <unordered_map>

    int main()
    {
       int nMax = 0;
       int index = 0;
       std::unordered_map<int, int> firstPos;

       for (int i = 1; i < 1000; i++)
       {
           int n = i;
           int position = 0;
           std::string period = "";
           int rem = 1;
           firstPos.clear();

           while (firstPos.find(rem) == firstPos.end())
           {
                firstPos[rem] = position;
                period += std::to_string(rem / n);
                rem = (rem % n) * 10;
                position += 1;
           }

           if (period.size() > nMax)
           {
                nMax = period.size();
                index = i;
           }
       }

       std::cout << nMax << std::endl;
       std::cout << index << std::endl;
    }
    ```
    Перебор всех чисел для поиска самого длинного периода
    
    
    
    
    ### Endless list
    ```
    create(Func, Start) ->
     spawn(endless_list, internal_loop, [Func, Start]).

    internal_loop(Func, Next) ->
      receive
       {Pid} ->
         Pid ! Next,
         NewNext = Func(Next),
         internal_loop(Func, NewNext);
        finished -> ok
      end.

    next(ListIter) ->
     ListIter ! {self()},
     receive
        Next -> Next
      after 10000 -> error
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
  ```
