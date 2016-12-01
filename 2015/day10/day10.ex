defmodule Day10 do
  @moduledoc """
  --- Day 10: Elves Look, Elves Say ---

  Today, the Elves are playing a game called look-and-say. They take turns making
  sequences by reading aloud the previous sequence and using that reading as the
  next sequence. For example, 211 is read as "one two, two ones", which becomes 1221 (1 2, 2 1s).

  Look-and-say sequences are generated iteratively, using the previous value as input
  for the next step. For each step, take the previous value, and replace each run of
  digits (like 111) with the number of digits (3) followed by the digit itself (1).

  For example:

  - 1 becomes 11 (1 copy of digit 1).
  - 11 becomes 21 (2 copies of digit 1).
  - 21 becomes 1211 (one 2 followed by one 1).
  - 1211 becomes 111221 (one 1, one 2, and two 1s).
  - 111221 becomes 312211 (three 1s, two 2s, and one 1).

  Starting with the digits in your puzzle input, apply this process 40 times. What is
  the length of the result?

  """

  def look_and_say(input) do
    input |> String.codepoints |> compress([])
  end

  defp compress([], compressed), do: stringify(compressed, [])
  defp compress([c | tail], [{c, n} | compressed]), do: compress(tail, [{c, n+1} | compressed])
  defp compress([c | tail], compressed),            do: compress(tail, [{c, 1} | compressed])

  defp stringify([], stringified), do: Enum.join(stringified)
  defp stringify([{c, n} | compressed], stringified), do: stringify(compressed, ["#{n}#{c}" | stringified])

end


ExUnit.start

defmodule Day10Test do
  use ExUnit.Case, async: true

  test "look_and_say" do
    assert "11" == Day10.look_and_say("1")
    assert "21" == Day10.look_and_say("11")
    assert "1211" == Day10.look_and_say("21")
    assert "1211" == Day10.look_and_say("21")
    assert "312211" == Day10.look_and_say("111221")
    assert "11131221133112" == Day10.look_and_say("1321131112")
  end

  test "input 1" do
    IO.puts "input 1"
    1..40
    |> Enum.reduce("1321131112", fn (_, prev) -> Day10.look_and_say(prev) end)
    |> String.length
    |> IO.puts
  end

  test "input 2" do
    IO.puts "input 2"
    1..50
    |> Enum.reduce("1321131112", fn (_, prev) -> Day10.look_and_say(prev) end)
    |> String.length
    |> IO.puts
  end

end
