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

  """

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
      containers: [
        11, 30, 47, 31, 32, 36, 3, 1, 5, 3, 32, 36, 15, 11, 46, 26, 28, 1, 19, 3,
      ]}
    }
  end

  test "simple" do
    containers = [20, 15, 10, 5, 5]

    combos = Day17.find_containers(containers, 25)

    assert 4 == Enum.count(combos)
  end

  test "input 1", %{containers: containers} do
    IO.puts "input 1"
    containers
    |> Day17.find_containers(150)
    |> IO.inspect
    |> Enum.count
    |> IO.inspect
  end

end
