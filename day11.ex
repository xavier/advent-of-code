defmodule Day11 do
  @moduledoc """
  --- Day 11: Corporate Policy ---

  Santa's previous password expired, and he needs help choosing a new one.

  To help him remember his new password after the old one expires, Santa has
  devised a method of coming up with a password based on the previous one.
  Corporate policy dictates that passwords must be exactly eight lowercase
  letters (for security reasons), so he finds his new password by incrementing his
  old password string repeatedly until it is valid.

  Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so on.
  Increase the rightmost letter one step; if it was z, it wraps around to a, and
  repeat with the next letter to the left until one doesn't wrap around.

  Unfortunately for Santa, a new Security-Elf recently started, and he has
  imposed some additional password requirements:

  - Passwords must include one increasing straight of at least three letters, like
    abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
  - Passwords may not contain the letters i, o, or l, as these letters can be mistaken
    for other characters and are therefore confusing.
  - Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.

  For example:

  - hijklmmn meets the first requirement (because it contains the straight hij) but
    fails the second requirement requirement (because it contains i and l).
  - abbceffg meets the third requirement (because it repeats bb and ff) but fails the
    first requirement.
  - abbcegjk fails the third requirement, because it only has one double letter (bb).
  - The next password after abcdefgh is abcdffaa.
  - The next password after ghijklmn is ghjaabcc, because you eventually skip all the
    passwords that start with ghi..., since i is not allowed.

  Given Santa's current password (your puzzle input), what should his next password be?

  """

  @alphabet ~w[a b c d e f g h i j k l m n o p q r s t u v w x y z]

  def next_password(current) do
    candidate = inc_password(current)
    if valid_password?(candidate) do
      candidate
    else
      next_password(candidate)
    end
  end

  def inc_password(string) do
    String.codepoints(string) |> Enum.reverse |> inc_with_carry |> Enum.reverse |> Enum.join
  end

  defp inc_with_carry([c|tail]) do
    case inc(c) do
      {c, true} ->
        [c|inc_with_carry(tail)]
      {c, false} ->
        [c|tail]
    end
  end

  def inc("z"), do: {"a", true}
  def inc(c), do: {find_next(c, @alphabet), false}

  defp find_next(c, [c, next|_]), do: next
  defp find_next(c, [_|tail]), do: find_next(c, tail)

  def valid_password?(s), do: !contains_invalid_character?(s) && increasing?(s) && count_pairs(s) > 1

  def increasing?(s) when is_binary(s), do: s |> String.codepoints |> increasing?
  def increasing?(list), do: find_increasing(list, @alphabet)

  defp find_increasing([], _), do: false
  defp find_increasing([_], _), do: false
  defp find_increasing([_, _], _), do: false
  defp find_increasing([x, y, z|_], [x, y, z|_]), do: true
  defp find_increasing([_, y, z|tail], [_, _]), do: find_increasing([y, z|tail], @alphabet)
  defp find_increasing([_, _, _|_] = l, [_|tail]), do: find_increasing(l, tail)

  def contains_invalid_character?(string), do: String.match?(string, ~r/[ilo]/)

  def count_pairs(s) when is_binary(s), do: s |> String.codepoints |> count_pairs
  def count_pairs(list), do: _count_pairs(list, 0)

  defp _count_pairs([], acc), do: acc
  defp _count_pairs([x, x|tail], acc), do: _count_pairs(tail, acc + 1)
  defp _count_pairs([_|tail], acc), do: _count_pairs(tail, acc)

end


ExUnit.start

defmodule Day11Test do
  use ExUnit.Case, async: true

  test "inc" do

    assert {"b", false} == Day11.inc("a")
    assert {"i", false} == Day11.inc("h")
    assert {"l", false} == Day11.inc("k")
    assert {"o", false} == Day11.inc("n")
    assert {"a", true}  == Day11.inc("z")

  end

  test "inc_password" do
    assert "xy" == Day11.inc_password("xx")
    assert "xz" == Day11.inc_password("xy")
    assert "ya" == Day11.inc_password("xz")
    assert "yb" == Day11.inc_password("ya")

    assert "baaaa", Day11.inc_password("azzzz")
  end

  test "increasing?" do
    assert Day11.increasing?("abc123")
    assert Day11.increasing?("123abc")
    assert Day11.increasing?("12abc3")
    assert Day11.increasing?("12abc3")
    assert Day11.increasing?("abhijkc")
  end

  test "count_pairs" do
    assert 0 == Day11.count_pairs("")
    assert 0 == Day11.count_pairs("abc")
    assert 1 == Day11.count_pairs("aabc")
    assert 1 == Day11.count_pairs("aaabc")
    assert 1 == Day11.count_pairs("abbc")
    assert 2 == Day11.count_pairs("abbcc")
    assert 2 == Day11.count_pairs("abbbcc")
  end

  test "valid_password?" do
    refute Day11.valid_password?("hijklmmn")
    refute Day11.valid_password?("abbceffg")
    refute Day11.valid_password?("abbcegjk")
  end

  test "next_password" do
    assert "abcdffaa" == Day11.next_password("abcdefgh")
  end

  @tag :skip
  test "next_password (slow)" do
    assert "ghjaabcc" == Day11.next_password("ghijklmn")
  end

  @tag timeout: 60_000
  test "input 1" do
    Day11.next_password("hepxcrrq")
    |> IO.inspect
    |> Day11.next_password
    |> IO.inspect
  end

end
