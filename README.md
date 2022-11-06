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

    tail_recursion(300000000, _) -> print_answer(0);

    tail_recursion(Number, true) -> print_answer(Number - 1);

    tail_recursion(Number, false) -> tail_recursion(Number + 1, is_divided_without_rem_on_seq(Number, 2, 20)).
    
    ```
    
    + __рекурсия__
    ```
    recursion_start() -> print_answer(recursion(1)).

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
   
2. __Filter реализация__
    ```
    filter_start() ->
      print_answer(
        lists:nth(
          1,
          [Y ||
            Y <- [X || X <- lists:seq(1, 300000000), X rem 2 == 0],
            is_divided_without_rem_on_seq(Y, 3, 20) == true])).
            
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
            lists:seq(Start, 300000000)
          ),
          X =/= 0
        ]
      ).

4. __реализация на любом удобном языке программировании__
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
    
    
### Problem 26

1. __Хвостовая рекурсия__
   ```
   tail_recursion_start() ->
     tail_recursion(1, 0).

    tail_recursion(1001, Max) ->
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
2. __Рекурсия__
   ```
   recursion_start() ->
     recursion(1, 0).

    recursion(1001, Max) ->
     Max;

    recursion(Number, Max) ->
     NewMax = recursion(Number + 1, Max),
      case string:length(period_generator(Number, 0, "", 1, maps:new())) of PeriodLen
       when PeriodLen > NewMax -> PeriodLen;
        _ -> NewMax
      end.
     
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
     
4. __Map implementation__
   ```
   map_start() -> map().

    map() -> element(2, map(1, get_prime_list(990), 0, 0)).

    map(1001, List, Max, _M) -> {List, Max + 1};

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
  
 5. __реализация на любом удобном языке программировании__
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
