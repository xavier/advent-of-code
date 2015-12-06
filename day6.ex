defmodule Day6 do
  @moduledoc """

  --- Day 6: Probably a Fire Hazard ---

  Because your neighbors keep defeating you in the holiday house decorating
  contest year after year, you've decided to deploy one million lights in
  a 1000x1000 grid.

  Furthermore, because you've been especially nice this year, Santa has
  mailed you instructions on how to display the ideal lighting configuration.

  Lights in your grid are numbered from 0 to 999 in each direction; the
  lights at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions
  include whether to turn on, turn off, or toggle various inclusive ranges given
  as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle,
  inclusive; a coordinate pair like 0,0 through 2,2 therefore refers to 9 lights in a 3x3
  square. The lights all start turned off.

  To defeat your neighbors this year, all you have to do is set up your lights by doing
  the instructions Santa sent you in order.

  For example:

  - turn on 0,0 through 999,999 would turn on (or leave on) every light.
  - toggle 0,0 through 999,0 would toggle the first line of 1000 lights,
    turning off the ones that were on, and turning on the ones that were off.
  - turn off 499,499 through 500,500 would turn off (or leave off) the middle
    four lights.

  After following the instructions, how many lights are lit?

  --- Part Two ---

  You just finish implementing your winning light pattern when you realize you
  mistranslated Santa's message from Ancient Nordic Elvish.

  The light grid you bought actually has individual brightness controls; each light
  can have a brightness of zero or more. The lights all start at zero.

  The phrase turn on actually means that you should increase the brightness of those
  lights by 1.

  The phrase turn off actually means that you should decrease the brightness of those
  lights by 1, to a minimum of zero.

  The phrase toggle actually means that you should increase the brightness of those
  lights by 2.

  What is the total brightness of all lights combined after following Santa's instructions?

  For example:

  - turn on 0,0 through 0,0 would increase the total brightness by 1.
  - toggle 0,0 through 999,999 would increase the total brightness by 2000000.

  """

  def command(grid, "turn on", from_coords, to_coords) do
    walk_grid(grid, from_coords, to_coords, &turn_on/2)
  end

  def command(grid, "turn off", from_coords, to_coords) do
    walk_grid(grid, from_coords, to_coords, &turn_off/2)
  end

  def command(grid, "toggle", from_coords, to_coords) do
    walk_grid(grid, from_coords, to_coords, &toggle/2)
  end

  defp walk_grid(grid, {x1, y1}, {x2, y2}, fun) when x1 <= x2 and y1 <= y2 do
    coords = for x <- x1..x2, y <- y1..y2, do: {x, y}
    Enum.reduce(coords, grid, fn (coord, grid) -> fun.(grid, coord) end)
  end

  def new_grid do
    Map.new
  end

  defp turn_on(grid, coords), do: increase_brightness(grid, coords, 1)

  defp toggle(grid, coords), do: increase_brightness(grid, coords, 2)

  defp increase_brightness(grid, coords, amount) do
    Dict.update(grid, coords, amount, fn (brightness) -> brightness + amount end)
  end

  defp turn_off(grid, coords) do
    case Dict.get(grid, coords) do
    nil ->
      grid
    1 ->
      Dict.delete(grid, coords)
    brightness ->
      Dict.put(grid, coords, brightness - 1)
    end
  end

  def total_brightness(grid) do
    grid
    |> Dict.values
    |> Enum.sum
  end

  # turn on 606,361 through 892,600
  # turn off 448,208 through 645,684
  # toggle 50,472 through 452,788
  def parse(line) do
    case Regex.run(~r/^(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)$/, line) do
    [_, command, x1, y1, x2, y2] ->
      [command, {to_int(x1), to_int(y1)}, {to_int(x2), to_int(y2)}]
    end
  end

  defp to_int(string), do: string |> Integer.parse |> elem(0)

end


ExUnit.start

defmodule Day6Part1Test do
  use ExUnit.Case, async: true

  @moduletag timeout: 5 * 60 * 1000

  test "turn on" do
    assert 1_000_000 == Enum.count(Day6.command(Day6.new_grid, "turn on", {0, 0}, {999, 999}))
  end

  test "turn off" do
    all_on = Day6.command(Day6.new_grid, "turn on", {0, 0}, {999, 999})
    assert (1_000_000-4) == Enum.count(Day6.command(all_on, "turn off", {499, 499}, {500, 500}))
  end

  test "toggle" do
    assert 1_000 == Enum.count(Day6.command(Day6.new_grid, "toggle", {0, 0}, {999, 0}))
  end

  test "total_brightness with turn on" do
    total_brightness =
      Day6.new_grid
      |> Day6.command("turn on", {0, 0}, {0, 0})
      |> Day6.total_brightness
    assert 1 == total_brightness
  end

  test "total_brightness with turn off" do
    total_brightness =
      Day6.new_grid
      |> Day6.command("turn on", {0, 0}, {1, 0})
      |> Day6.command("turn off", {0, 0}, {0, 0})
      |> Day6.total_brightness
    assert 1 == total_brightness
  end

  test "total_brightness with toggle" do
    total_brightness =
      Day6.new_grid
      |> Day6.command("toggle", {0, 0}, {999, 999})
      |> Day6.total_brightness
    assert 2_000_000 == total_brightness
  end

  test "input part 1" do
    IO.puts "lights on"
    File.stream!("day6.txt")
    |> Stream.map(&Day6.parse/1)
    |> Enum.reduce(Day6.new_grid, fn ([cmd, c1, c2], grid) -> Day6.command(grid, cmd, c1, c2) end)
    |> Enum.count
    |> IO.puts
  end

  test "input part 2" do
    IO.puts "total brightness"
    File.stream!("day6.txt")
    |> Stream.map(&Day6.parse/1)
    |> Enum.reduce(Day6.new_grid, fn ([cmd, c1, c2], grid) -> Day6.command(grid, cmd, c1, c2) end)
    |> Day6.total_brightness
    |> IO.puts
  end
end
