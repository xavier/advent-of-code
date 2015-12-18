defmodule Day18 do
  @moduledoc """

  --- Day 18: Like a GIF For Your Yard ---

  After the million lights incident, the fire code has gotten stricter:
  now, at most ten thousand lights are allowed. You arrange them in a 100x100 grid.

  Never one to let you down, Santa again mails you instructions on the ideal
  lighting configuration. With so few lights, he says, you'll have to resort to animation.

  Start by setting your lights to the included initial configuration (your puzzle input).
  A # means "on", and a . means "off".

  Then, animate your grid in steps, where each step decides the next configuration based
  on the current one. Each light's next state (either on or off) depends on its current
  state and the current states of the eight lights adjacent to it (including diagonals).
  Lights on the edge of the grid might have fewer than eight neighbors; the missing
  ones always count as "off".

  For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered
  1 through 8, and the light marked B, which is on an edge, only has the neighbors
  marked 1 through 5:

  1B5...
  234...
  ......
  ..123.
  ..8A4.
  ..765.

  The state a light should have next is based on its current state (on or off) plus
  the number of neighbors that are on:

  - A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
  - A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.

  All of the lights update simultaneously; they all consider the same current state
  before moving to the next.

  Here's a few steps from an example configuration of another 6x6 grid:

  Initial state:

  .#.#.#
  ...##.
  #....#
  ..#...
  #.#..#
  ####..

  After 1 step:

  ..##..
  ..##.#
  ...##.
  ......
  #.....
  #.##..

  After 2 steps:

  ..###.
  ......
  ..###.
  ......
  .#....
  .#....

  After 3 steps:

  ...#..
  ......
  ...#..
  ..##..
  ......
  ......

  After 4 steps:

  ......
  ......
  ..##..
  ..##..
  ......
  ......

  After 4 steps, this example has four lights on.

  In your grid of 100x100 lights, given your initial configuration,
  how many lights are on after 100 steps?

  """

  def new_grid do
    HashDict.new
  end

  defp turn_on(grid, coords),  do: Dict.put(grid, coords, true)
  defp turn_off(grid, coords), do: Dict.delete(grid, coords)

  defp toggle(grid, coords, true),  do: turn_on(grid, coords)
  defp toggle(grid, coords, false), do: turn_off(grid, coords)

  def is_on?(_, {x, y}) when x < 0 or x > 99 or y < 0 or y > 99, do: false
  def is_on?(grid, coords), do: Dict.has_key?(grid, coords)

  def next_grid(grid, size \\ 100) do
    grid_coords(size - 1)
    |> Enum.reduce(new_grid, fn(coords, g) ->
      toggle(g, coords, next_light_state(grid, coords))
    end)
  end

  def grid_coords(max) do
    Stream.flat_map(0..max, fn x ->
      Stream.flat_map(0..max, fn y ->
        [{x, y}]
      end)
    end)
  end

  def next_light_state(grid, coords) do
    case {is_on?(grid, coords), count_neighbors(grid, coords)} do
      {true, 2}  -> true
      {true, 3}  -> true
      {false, 3} -> true
      _ -> false
    end
  end

  @neighbor_offsets [
      {-1, -1}, {0, -1}, {1, -1},
      {-1,  0},          {1,  0},
      {-1,  1}, {0,  1}, {1,  1},
    ]

  def count_neighbors(grid, {x, y}) do
    @neighbor_offsets
    |> Enum.reduce(0, fn ({ox, oy}, acc) ->
      if is_on?(grid, {x+ox, y+oy}), do: acc + 1, else: acc
    end)
  end

  def parse_grid(text) do
    text
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(new_grid, fn ({line, y}, g) -> parse_line(line, y, g) end)
  end

  def parse_line(line, y, grid) do
    line
    |> String.codepoints
    |> Enum.with_index
    |> Enum.reduce(grid, fn ({char, x}, g) -> initial_state(g, {x, y}, char) end)
  end

  defp initial_state(grid, coords, "#"), do: turn_on(grid, coords)
  defp initial_state(grid, _, "."), do: grid

end


ExUnit.start

defmodule Day18Part1Test do
  use ExUnit.Case, async: true

  @moduletag timeout: 5 * 60 * 1000

  test "simple" do

    text = ".#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####.."

    grid = Day18.parse_grid(text)

    assert 15 == Enum.count(grid)

    refute Day18.is_on?(grid, {0, 0})
    assert Day18.is_on?(grid, {1, 0})
    refute Day18.is_on?(grid, {2, 0})
    assert Day18.is_on?(grid, {5, 0})
    assert Day18.is_on?(grid, {0, 5})
    refute Day18.is_on?(grid, {5, 5})

    refute Day18.is_on?(grid, {-1, 0})
    refute Day18.is_on?(grid, {0, -1})
    refute Day18.is_on?(grid, {123, 0})
    refute Day18.is_on?(grid, {0, 123})

    assert 1 == Day18.count_neighbors(grid, {0, 0})
    assert 2 == Day18.count_neighbors(grid, {3, 0})
    assert 3 == Day18.count_neighbors(grid, {2, 5})

    count =
      grid
      |> Day18.next_grid(6)
      |> Day18.next_grid(6)
      |> Day18.next_grid(6)
      |> Day18.next_grid(6)
      |> Enum.count

    assert 4 == count

  end

  test "input part 1" do
    IO.puts "part 1"

    initial_grid =
      File.read!("day18.txt")
      |> Day18.parse_grid

    1..100
    |> Enum.reduce(initial_grid, fn (_, grid) -> Day18.next_grid(grid) end)
    |> Enum.count
    |> IO.puts
  end

end
