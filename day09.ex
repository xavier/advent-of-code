defmodule Day9 do

  @moduledoc """

  --- Day 9: All in a Single Night ---

  Every year, Santa manages to deliver all of his presents in a single night.

  This year, however, he has some new locations to visit; his elves have provided him the distances between every pair of locations. He can start and end at any two (different) locations he wants, but he must visit each location exactly once. What is the shortest distance he can travel to achieve this?

  For example, given the following distances:

  London to Dublin = 464
  London to Belfast = 518
  Dublin to Belfast = 141
  The possible routes are therefore:

  Dublin -> London -> Belfast = 982
  London -> Dublin -> Belfast = 605
  London -> Belfast -> Dublin = 659
  Dublin -> Belfast -> London = 659
  Belfast -> Dublin -> London = 605
  Belfast -> London -> Dublin = 982
  The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.

  What is the distance of the shortest route?

  Your puzzle answer was 207.

  --- Part Two ---

  The next year, just to show off, Santa decides to take the route with the longest distance instead.

  He can still start and end at any two (different) locations he wants, and he still must visit each location exactly once.

  For example, given the distances above, the longest route would be 982 via (for example) Dublin -> London -> Belfast.

  What is the distance of the longest route?

  """

  def parse(line) do
    [v1, "to", v2, "=", w] = line |> String.strip |> String.split
    {v1, v2, Integer.parse(w) |> elem(0)}
  end

  def build_graph({v1, v2, w}, graph) do
    graph
    |> Dict.update(v1, Dict.put(HashDict.new, v2, w), fn (vertices) -> Dict.put(vertices, v2, w) end)
    |> Dict.update(v2, Dict.put(HashDict.new, v1, w), fn (vertices) -> Dict.put(vertices, v1, w) end)
  end

  def distance(graph, v1, v2) do
    Dict.get(graph, v1) |> Dict.get(v2)
  end

  def all_paths(graph) do
    graph |> Dict.keys |> permutations
  end

  def total_distance(graph, path), do: calc_total_distance(graph, path, 0)
  defp calc_total_distance(_graph, [], acc), do: acc
  defp calc_total_distance(graph, [v1, v2], acc), do: acc + distance(graph, v1, v2)
  defp calc_total_distance(graph, [v1, v2 | rest], acc) do
    calc_total_distance(graph, [v2 | rest], acc + distance(graph, v1, v2))
  end

  def permutations([]), do: [[]]
  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h|t]
  end

end


ExUnit.start

defmodule Day9Test do
  use ExUnit.Case, async: true

  test "shortest_path" do
    graph = HashDict.new
    graph = Day9.build_graph({"London", "Dublin", 464}, graph)
    graph = Day9.build_graph({"London", "Belfast", 518}, graph)
    graph = Day9.build_graph({"Dublin", "Belfast", 141}, graph)

    expected =
      graph
      |> Day9.all_paths
      |> Enum.map(fn (path) -> {path, Day9.total_distance(graph, path)} end)
      |> IO.inspect
      |> Enum.map(&elem(&1, 1))
      |> Enum.min

    assert 605 == expected

  end

  test "input" do

    graph =
      File.stream!("day09.txt")
      |> Stream.map(&Day9.parse/1)
      |> Enum.reduce(HashDict.new, &Day9.build_graph/2)

    graph
    |> Day9.all_paths
    |> Enum.map(fn (path) -> Day9.total_distance(graph, path) end)
    |> Enum.min_max
    |> IO.inspect

  end

end
