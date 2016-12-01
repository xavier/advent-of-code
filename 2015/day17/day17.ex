defmodule Day17 do
  @moduledoc """
  --- Day 17: No Such Thing as Too Much ---

  The elves bought too much eggnog again - 150 liters this time.
  To fit it all into your refrigerator, you'll need to move it into smaller containers.
  You take an inventory of the capacities of the available containers.

  For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters.
  If you need to store 25 liters, there are four ways to do it:

  - 15 and 10
  - 20 and 5 (the first 5)
  - 20 and 5 (the second 5)
  - 15, 5, and 5

  Filling all containers entirely, how many different combinations of containers
  can exactly fit all 150 liters of eggnog?

  --- Part Two ---

  While playing with all the containers in the kitchen, another load of eggnog arrives!
  The shipping and receiving department is requesting as many containers as you can spare.

  Find the minimum number of containers that can exactly fit all 150 liters of eggnog.
  How many different ways can you fill that number of containers and still hold exactly 150 litres?

  In the example above, the minimum number of containers was two.
  There were three ways to use that many containers, and so the answer there would be 3.

  """

  def find_optimal_containers(containers, quantity) do
    by_size =
      containers
      |> find_containers(quantity)
      |> Enum.group_by(fn (combo) -> Enum.count(combo) end)

    smallest =
      by_size
      |> Dict.keys
      |> Enum.min

    by_size |> Dict.get(smallest, [])
  end

  def find_containers(containers, quantity) do
    containers
    |> powerset
    |> Enum.filter(&fits?(&1, quantity))
  end

  def fits?(containers, quantity) do
    Enum.sum(containers) == quantity
  end

  defp powerset(list) do
    Enum.reduce(list, [[]], fn (item, set) ->
      set ++ Enum.map(set, fn(x) -> [item|x] end)
    end)
  end

end

ExUnit.start

defmodule Day17Test do
  use ExUnit.Case, async: true

  setup do
    {:ok, %{
      test_containers: [
        20, 15, 10, 5, 5
      ],
      input_containers: [
        11, 30, 47, 31, 32, 36, 3, 1, 5, 3, 32, 36, 15, 11, 46, 26, 28, 1, 19, 3,
      ]}
    }
  end

  test "acceptance part 1", %{test_containers: containers} do
    combos = Day17.find_containers(containers, 25)

    assert 4 == Enum.count(combos)
  end

  test "acceptance part 2", %{test_containers: containers} do
    combos = Day17.find_optimal_containers(containers, 25)

    assert 3 == Enum.count(combos)
  end

  test "input 1", %{input_containers: containers} do
    IO.puts "input 1"
    containers
    |> Day17.find_containers(150)
    |> Enum.count
    |> IO.inspect
  end

  test "input 2", %{input_containers: containers} do
    IO.puts "input 2"
    containers
    |> Day17.find_optimal_containers(150)
    |> Enum.count
    |> IO.inspect
  end

end
