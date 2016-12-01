defmodule Day16 do
  @moduledoc """
  --- Day 16: Aunt Sue ---

  Your Aunt Sue has given you a wonderful gift, and you'd like to send her
  a thank you card. However, there's a small problem: she signed it "From, Aunt Sue".

  You have 500 Aunts named "Sue".

  So, to avoid sending the card to the wrong person, you need to figure out which
  Aunt Sue (which you conveniently number 1 to 500, for sanity) gave you the gift.
  You open the present and, as luck would have it, good ol' Aunt Sue got you a
  My First Crime Scene Analysis Machine! Just what you wanted. Or needed, as
  the case may be.

  The My First Crime Scene Analysis Machine (MFCSAM for short) can detect a few
  specific compounds in a given sample, as well as how many distinct kinds of
  those compounds there are. According to the instructions, these are what the
  MFCSAM can detect:

  - children, by human DNA age analysis.
  - cats. It doesn't differentiate individual breeds.
  - Several seemingly random breeds of dog: samoyeds, pomeranians, akitas, and vizslas.
  - goldfish. No other kinds of fish.
  - trees, all in one group.
  - cars, presumably by exhaust or gasoline or something.
  - perfumes, which is handy, since many of your Aunts Sue wear a few kinds.

  In fact, many of your Aunts Sue have many of these. You put the wrapping
  from the gift into the MFCSAM. It beeps inquisitively at you a few times
  and then prints out a message on ticker tape:

  children: 3
  cats: 7
  samoyeds: 2
  pomeranians: 3
  akitas: 0
  vizslas: 0
  goldfish: 5
  trees: 3
  cars: 2
  perfumes: 1

  You make a list of the things you can remember about each Aunt Sue.
  Things missing from your list aren't zero - you simply don't remember the value.

  What is the number of the Sue that got you the gift?

  --- Part Two ---

  As you're about to send the thank you note, something in the MFCSAM's instructions
  catches your eye. Apparently, it has an outdated retroencabulator, and so the output
  from the machine isn't exact values - some of them indicate ranges.

  In particular, the cats and trees readings indicates that there are greater than
  that many (due to the unpredictable nuclear decay of cat dander and tree pollen),
  while the pomeranians and goldfish readings indicate that there are fewer than
  that many (due to the modial interaction of magnetoreluctance).

  What is the number of the real Aunt Sue?

  """

  @regex_line ~r/^Sue (\d+): (.*)$/

  def parse(line) do
    case Regex.run(@regex_line, line) do
      [_, sue_no, key_value_string] ->
        {to_int(sue_no), parse_key_value(key_value_string)}
    end
  end

  @regex_key_value ~r/\b(\w+): (\d+)/
  defp parse_key_value(string) do
    @regex_key_value
    |> Regex.scan(string)
    |> Enum.into(%{}, fn ([_, k, v]) -> {k, to_int(v)} end)
  end

  defp to_int(s), do: s |> Integer.parse |> elem(0)

  def find_aunt(facts, analysis) do
    analysis
    |> Enum.reduce(facts, fn ({key, value}, facts) ->
      Enum.filter(facts, &keep?(key, value, &1))
    end)
  end

  defp keep?(key, value, facts) when key in ~w[cats trees] do
    compare_value?(key, value, facts, :gt)
  end
  defp keep?(key, value, facts) when key in ~w[pomeranians goldfish] do
    compare_value?(key, value, facts, :lt)
  end
  defp keep?(key, value, facts) do
    compare_value?(key, value, facts)
  end

  defp compare_value?(key, value, {_, facts}, op \\ :eq) do
    v = Dict.get(facts, key)
    cond do
      op == :lt && v < value -> true
      op == :gt && v > value -> true
      op == :eq && v == value -> true
      v == nil -> true
      true -> false
    end
  end

end

ExUnit.start

defmodule Day16Test do
  use ExUnit.Case, async: true

  setup do
    {:ok, %{
      analysis: %{
        "children" => 3,
        "cats" => 7,
        "samoyeds" => 2,
        "pomeranians" => 3,
        "akitas" => 0,
        "vizslas" => 0,
        "goldfish" => 5,
        "trees" => 3,
        "cars" => 2,
        "perfumes" => 1,
      }
    }}
  end

  test "parse" do
    expected = {13, %{"akitas" => 10, "pomeranians" => 0, "vizslas" => 2}}
    assert expected == Day16.parse("Sue 13: akitas: 10, pomeranians: 0, vizslas: 2")
  end

  test "input 1", %{analysis: analysis} do
    File.stream!("day16.txt")
    |> Enum.map(&Day16.parse/1)
    |> Day16.find_aunt(analysis)
    |> IO.inspect
  end
end
