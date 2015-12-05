defmodule Day5 do
  @moduledoc """

  --- Day 5: Doesn't He Have Intern-Elves For This? ---

  Santa needs help figuring out which strings in his text file are naughty or nice.

  A nice string is one with all of the following properties:

  - It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
  - It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or
    aabbccdd (aa, bb, cc, or dd).
  - It does not contain the strings ab, cd, pq, or xy, even if they are part of one of
    the other requirements.

  For example:

  - ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...),
    a double letter (...dd...), and none of the disallowed substrings.
  - aaa is nice because it has at least three vowels and a double letter, even
    though the letters used by different rules overlap.
  - jchzalrnumimnmhp is naughty because it has no double letter.
  - haegwjzuvuyypxyu is naughty because it contains the string xy.
  - dvszwmarrgswjxmb is naughty because it contains only one vowel.

  How many strings are nice?

  """

  def nice?(string) do
    enough_vowels?(string) && letters_in_a_row?(string) && !forbidden?(string)
  end

  defp enough_vowels?(string), do: count_vowels(string) > 2

  @not_vowels ~r/[^aeiou]/

  defp count_vowels(string) do
    string
    |> String.replace(@not_vowels, "")
    |> String.length
  end

  @letters_in_a_row ~r/([a-z])\1/

  defp letters_in_a_row?(string), do: String.match?(string, @letters_in_a_row)

  @forbidden ~r/ab|cd|pq|xy/

  defp forbidden?(string), do: String.match?(string, @forbidden)

end


ExUnit.start

defmodule Day5Test do
  use ExUnit.Case, async: true

  test "nice?" do
    assert Day5.nice?("ugknbfddgicrmopn")
    assert Day5.nice?("aaa")
    refute Day5.nice?("jchzalrnumimnmhp")
    refute Day5.nice?("haegwjzuvuyypxyu")
    refute Day5.nice?("dvszwmarrgswjxmb")
  end

  test "count" do
    File.stream!("day5.txt")
    |> Enum.filter(&Day5.nice?/1)
    |> Enum.count
    |> IO.puts
  end
end
