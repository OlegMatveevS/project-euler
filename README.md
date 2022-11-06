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

6. __реализация на любом удобном языке программировании__
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
