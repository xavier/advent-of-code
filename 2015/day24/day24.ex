defmodule Day24 do
  @moduledoc """
  --- Day 24: It Hangs in the Balance ---

  It's Christmas Eve, and Santa is loading up the sleigh for
  this year's deliveries. However, there's one small problem:
  he can't get the sleigh to balance. If it isn't balanced,
  he can't defy physics, and nobody gets presents this year.

  No pressure.

  Santa has provided you a list of the weights of every
  package he needs to fit on the sleigh. The packages need
  to be split into three groups of exactly the same weight,
  and every package has to fit. The first group goes in the
  passenger compartment of the sleigh, and the second and
  third go in containers on either side. Only when all
  three groups weigh exactly the same amount will the
  sleigh be able to fly. Defying physics has rules, you know!

  Of course, that's not the only problem. The first group -
  the one going in the passenger compartment - needs as few
  packages as possible so that Santa has some legroom left
  over. It doesn't matter how many packages are in either
  of the other two groups, so long as all of the groups
  weigh the same.

  Furthermore, Santa tells you, if there are multiple ways
  to arrange the packages such that the fewest possible
  are in the first group, you need to choose the way
  where the first group has the smallest quantum
  entanglement to reduce the chance of any "complications".
  The quantum entanglement of a group of packages is the
  product of their weights, that is, the value you get
  when you multiply their weights together. Only
  consider quantum entanglement if the first group has
  the fewest possible number of packages in it and all
  groups weigh the same amount.

  For example, suppose you have ten packages with
  weights 1 through 5 and 7 through 11. For this situation,
  the unique first groups, their quantum entanglements,
  and a way to divide the remaining packages are as follows:

  Group 1;             Group 2; Group 3
  11 9       (QE= 99); 10 8 2;  7 5 4 3 1
  10 9 1     (QE= 90); 11 7 2;  8 5 4 3
  10 8 2     (QE=160); 11 9;    7 5 4 3 1
  10 7 3     (QE=210); 11 9;    8 5 4 2 1
  10 5 4 1   (QE=200); 11 9;    8 7 3 2
  10 5 3 2   (QE=300); 11 9;    8 7 4 1
  10 4 3 2 1 (QE=240); 11 9;    8 7 5
  9 8 3      (QE=216); 11 7 2;  10 5 4 1
  9 7 4      (QE=252); 11 8 1;  10 5 3 2
  9 5 4 2    (QE=360); 11 8 1;  10 7 3
  8 7 5      (QE=280); 11 9;    10 4 3 2 1
  8 5 4 3    (QE=480); 11 9;    10 7 2 1
  7 5 4 3 1  (QE=420); 11 9;    10 8 2

  Of these, although 10 9 1 has the smallest quantum
  entanglement (90), the configuration with only two
  packages, 11 9, in the passenger compartment gives
  Santa the most legroom and wins. In this situation,
  the quantum entanglement for the ideal configuration
  is therefore 99. Had there been two configurations
  with only two packages in the first group, the one
  with the smaller quantum entanglement would be chosen.

  What is the quantum entanglement of the first group
  of packages in the ideal configuration?

  """
  #import itertools
  #import operator


  def solve(items, num_groups \\ 3) do
    group_sum = div(Enum.sum(items), num_groups)

    foo =
      for len <- 1..length(items),
        c <- valid_combinations(items, len, group_sum) do
        IO.puts len
        IO.inspect c
        qes = Enum.map(c, fn (cc) -> Enum.reduce(cc, &Kernel.*/2) end)
        if length(qes) > 0 do
          IO.puts Enum.min(qes)
          raise "stop"
        end
      end
  end

  def valid_combinations(items, length, tot) do
    combinations(items, length)
    |> Enum.filter(fn (comb) -> Enum.sum(comb) == tot end)
  end

  # def in_groups(items, group_size) do
  #   in_groups(items, group_size, 0, [])
  # end
  # def in_groups([], size, size, groups), do: groups
  # def in_groups([], _, _, _), do: :impossible
  # def in_groups([item|rest], group_size, 0, groups) do
  #   in_groups(rest, group_size, item, [[item]|groups])
  # end
  # def in_groups([item|rest], group_size, current_size, [current_group|other_groups]) do
  #   new_current_size = current_size + item
  #   cond do
  #     new_current_size < group_size ->
  #       in_groups(rest, group_size, new_current_size, [[item|current_group]|other_groups])
  #     new_current_size == group_size ->
  #       in_groups(rest, group_size, 0, [[item|current_group]|other_groups])
  #     new_current_size > group_size ->
  #       :impossible
  #   end
  # end

  # def permutations([]), do: [[]]
  # def permutations(list) do
  #   for h <- list, t <- permutations(list -- [h]), do: [h|t]
  # end

  def combinations(enum, k) do
    do_combinations(enum, k)
    |> List.last
    |> Enum.uniq
  end

  defp do_combinations(enum, k) do
    combinations_by_length = [[[]]|List.duplicate([], k)]

    list = Enum.to_list(enum)
    List.foldr list, combinations_by_length, fn x, next ->
      sub = :lists.droplast(next)
      step = [[]|(for l <- sub, do: (for s <- l, do: [x|s]))]
      :lists.zipwith(&:lists.append/2, step, next)
    end
  end
end

ExUnit.start

defmodule Day24Test do
  use ExUnit.Case, async: true

  setup do
    {:ok,
      %{
        example: [
          1, 2, 3, 4, 5,
          7, 8, 9, 10, 11
        ],
        input: [
          1, 2, 3, 5, 7,
          13, 17, 19, 23, 29,
          31, 37, 41, 43, 53,
          59, 61, 67, 71, 73,
          79, 83, 89, 97, 101,
          103, 107, 109, 113,
        ]
      }
    }
  end

  test "example", %{example: example} do
    Day24.solve(example)
    |> IO.inspect
  end

  test "part 1", %{input: input} do
    IO.puts "part 1"
    Day24.solve(input, 3)
    |> IO.inspect
  end

  test "part 2", %{input: input} do
    IO.puts "part 2"
    Day24.solve(input, 4)
    |> IO.inspect
  end
end
