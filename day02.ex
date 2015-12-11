defmodule Day2 do
  @moduledoc """
  --- Day 2: I Was Told There Would Be No Math ---

  The elves are running low on wrapping paper, and so they need to
  submit an order for more. They have a list of the dimensions
  (length l, width w, and height h) of each present, and only
  want to order exactly as much as they need.

  Fortunately, every present is a box (a perfect right rectangular prism),
  which makes calculating the required wrapping paper for each gift a little
  easier: find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l.
  The elves also need a little extra paper for each present: the area of
  the smallest side.

  For example:

  - A present with dimensions 2x3x4 requires 2*6 + 2*12 + 2*8 = 52 square
    feet of wrapping paper plus 6 square feet of slack, for a total of 58 square feet.
  - A present with dimensions 1x1x10 requires 2*1 + 2*10 + 2*10 = 42 square feet
    of wrapping paper plus 1 square foot of slack, for a total of 43 square feet.

  All numbers in the elves' list are in feet.
  How many total square feet of wrapping paper should they order?

  """

  def paper_surface(l, w, h) do
    sides = [l * w, w * h, h * l]
    paper = Enum.min(sides)
    Enum.reduce(sides, paper, fn(x, acc) -> acc + x * 2 end)
  end

  def ribbon_length(l, w, h) do
    bow = l * w * h
    bow + 2 * Enum.min([l + w, w + h, h + l])
  end

end


ExUnit.start

defmodule Day2Test do
  use ExUnit.Case, async: true

  test "paper_surface" do
    assert 58 == Day2.paper_surface(2, 3, 4)
    assert 43 == Day2.paper_surface(1, 1, 10)
  end

  test "ribbon_length" do
    assert 34 == Day2.ribbon_length(2, 3, 4)
    assert 14 == Day2.ribbon_length(1, 1, 10)
  end

  test "input" do
    File.stream!("day02.txt")
    |> Stream.map(fn (string) -> String.split(string, "x") end)
    |> Stream.map(fn (strings) -> Enum.map(strings, &string_to_int/1) end)
    |> Enum.reduce({0, 0}, fn([l, w, h], {surface, length}) ->
      {surface + Day2.paper_surface(l, w, h), length + Day2.ribbon_length(l, w, h)}
    end)
    |> IO.inspect
  end

  defp string_to_int(s), do: Integer.parse(s) |> elem(0)
end
