defmodule Day12 do

  @moduledoc """

  --- Day 12: JSAbacusFramework.io ---

  Santa's Accounting-Elves need help balancing the books after a recent order.
  Unfortunately, their accounting software uses a peculiar storage format.
  That's where you come in.

  They have a JSON document which contains a variety of things: arrays ([1,2,3]),
  objects ({"a":1, "b":2}), numbers, and strings. Your first job is to simply
  find all of the numbers throughout the document and add them together.

  For example:

  - [1,2,3] and {"a":2,"b":4} both have a sum of 6.
  - [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
  - {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
  - [] and {} both have a sum of 0.

  You will not encounter any strings containing numbers.

  What is the sum of all numbers in the document?

  --- Part Two ---

  Uh oh - the Accounting-Elves have realized that they double-counted everything red.

  Ignore any object (and all of its children) which has any property with the value
  "red". Do this only for objects ({...}), not arrays ([...]).

  - [1,2,3] still has a sum of 6.
  - [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
  - {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is
    ignored.
  - [1,"red",5] has a sum of 6, because "red" in an array has no effect.

  """

  def sum_all_numbers(obj), do: sum(obj, 0)

  def sum(x, acc) when is_number(x), do: x + acc
  def sum(obj, acc) when is_map(obj), do: sum(Dict.values(obj), acc)
  def sum([x|tail], acc), do: sum(tail, sum(x, acc))
  def sum(_, acc), do: acc

  def sum_all_numbers_except_red(obj), do: sum_except_red(obj, 0)

  def sum_except_red(x, acc) when is_number(x), do: x + acc
  def sum_except_red(obj, acc) when is_map(obj) do
    values = Dict.values(obj)
    if Enum.member?(values, "red") do
      acc
    else
      sum_except_red(values, acc)
    end
  end
  def sum_except_red([x|tail], acc), do: sum_except_red(tail, sum_except_red(x, acc))
  def sum_except_red(_, acc), do: acc

end
