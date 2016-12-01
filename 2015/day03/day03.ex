defmodule Day3 do
  @moduledoc """
  --- Day 3: Perfectly Spherical Houses in a Vacuum ---

  Santa is delivering presents to an infinite two-dimensional grid of houses.

  He begins by delivering a present to the house at his starting location, and
  then an elf at the North Pole calls him via radio and tells him where to move next.
  Moves are always exactly one house to the north (^), south (v), east (>), or west (<).
  After each move, he delivers another present to the house at his new location.

  However, the elf back at the north pole has had a little too much eggnog, and so
  his directions are a little off, and Santa ends up visiting some houses more than once.

  How many houses receive at least one present?

  For example:

  - > delivers presents to 2 houses: one at the starting location, and one to the east.
  - ^>v< delivers presents to 4 houses in a square, including twice to the house at his
    starting/ending location.
  - ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.


  """

  def count_houses(moves), do: visit(moves, {0, 0}) |> Set.size

  defp visit(moves, pos), do: visit(moves, pos, HashSet.new)

  defp visit("", pos, visited), do: Set.put(visited, pos)
  defp visit(">" <> moves, {x, y}, visited), do: visit(moves, {x + 1, y}, Set.put(visited, {x, y}))
  defp visit("<" <> moves, {x, y}, visited), do: visit(moves, {x - 1, y}, Set.put(visited, {x, y}))
  defp visit("^" <> moves, {x, y}, visited), do: visit(moves, {x, y + 1}, Set.put(visited, {x, y}))
  defp visit("v" <> moves, {x, y}, visited), do: visit(moves, {x, y - 1}, Set.put(visited, {x, y}))

  def count_houses_robot(moves) do
    {santa_moves, robot_moves} = split_workload(moves)

    santa_visits = visit(santa_moves, {0, 0})
    robot_visits = visit(robot_moves, {0, 0})

    Set.union(santa_visits, robot_visits) |> Set.size
  end

  defp split_workload(moves) do
    {santa_moves, robot_moves} =
      moves
      |> String.codepoints
      |> Enum.with_index
      |> Enum.partition(fn {move, idx} -> rem(idx, 2) == 0 end)
    {rebuild_moves(santa_moves), rebuild_moves(robot_moves)}
  end

  defp rebuild_moves(pairs) do
    Enum.map_join(pairs, &(elem(&1, 0)))
  end

end


ExUnit.start

defmodule Day3Test do
  use ExUnit.Case, async: true

  test "count_houses" do
    assert 2 == Day3.count_houses(">")
    assert 4 == Day3.count_houses("^>v<")
    assert 2 == Day3.count_houses("^v^v^v^v^v")
  end

  test "count_houses_robot" do
    assert 3 == Day3.count_houses_robot("^v")
    assert 3 == Day3.count_houses_robot("^>v<")
    assert 11 == Day3.count_houses_robot("^v^v^v^v^v")
  end

  test "input count_houses" do
    IO.puts "count_houses"
    File.read!("day03.txt")
    |> Day3.count_houses
    |> IO.puts
  end

  test "input count_houses_robot" do
    IO.puts "count_houses_robot"
    File.read!("day03.txt")
    |> Day3.count_houses_robot
    |> IO.puts
  end
end
