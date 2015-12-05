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

  --- Part Two ---

  Realizing the error of his ways, Santa has switched to a better model of determining
  whether a string is naughty or nice. None of the old rules apply, as they are all clearly ridiculous.

  Now, a nice string is one with all of the following properties:

  - It contains a pair of any two letters that appears at least twice in the string without overlapping,
    like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
  - It contains at least one letter which repeats with exactly one letter between them, like xyx,
    abcdefeghi (efe), or even aaa.

  For example:

  - qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter
    that repeats with exactly one letter between them (zxz).
  - xxyxx is nice because it has a pair that appears twice and a letter that repeats
    with one between, even though the letters used by each rule overlap.
  - uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single
    letter between them.
  - ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo),
    but no pair that appears twice

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

  def nice2?(string) do
    has_pair_twice?(string) && has_repeating_letter?(string)
  end

  def has_pair_twice?(<<_>>), do: false
  def has_pair_twice?(<<_, _>>), do: false
  def has_pair_twice?(<<a, b>> <> rest), do: String.contains?(rest, <<a, b>>) || has_pair_twice?(<<b>> <> rest)

  @repeating_letter ~r/([a-z]).\1/

  def has_repeating_letter?(string), do: String.match?(string, @repeating_letter)

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

  test "nice2?" do
    assert Day5.nice2?("qjhvhtzxzqqjkmpb")
    assert Day5.nice2?("xxyxx")
    refute Day5.nice2?("uurcxstgmygtbstg")
    refute Day5.nice2?("ieodomkazucvgmuy")
  end

  test "count nice" do
    IO.puts "nice"
    File.stream!("day5.txt")
    |> Enum.filter(&Day5.nice?/1)
    |> Enum.count
    |> IO.puts
  end

  test "count nice2" do
    IO.puts "nice2"
    File.stream!("day5.txt")
    |> Enum.filter(&Day5.nice2?/1)
    |> Enum.count
    |> IO.puts
  end
end
