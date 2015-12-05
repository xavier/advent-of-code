defmodule Day4 do
  @moduledoc """

  --- Day 4: The Ideal Stocking Stuffer ---

  Santa needs help mining some AdventCoins (very similar to bitcoins) to use as
  gifts for all the economically forward-thinking little girls and boys.

  To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least
  five zeroes. The input to the MD5 hash is some secret key (your puzzle input,
  given below) followed by a number in decimal. To mine AdventCoins, you must find
  Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces
  such a hash.

  For example:

  - If your secret key is abcdef, the answer is 609043, because the MD5 hash
    of abcdef609043 starts with five zeroes (000001dbbfa...), and it is the
    lowest such number to do so.
  - If your secret key is pqrstuv, the lowest number it combines with to make
    an MD5 hash starting with five zeroes is 1048970; that is, the MD5 hash of
    pqrstuv1048970 looks like 000006136ef....

  """

  def mine(secret) do
    Stream.iterate(1, fn (x) -> x + 1 end)
    |> Enum.find(fn (x) -> advent_coin?(secret, x) end)
  end

  defp advent_coin?(secret, x) do
    case md5("#{secret}#{x}") do
      "00000" <> _ -> true
      _ -> false
    end
  end

  defp md5(data), do: :erlang.md5(data) |> Base.encode16(case: :lower)

end


ExUnit.start

defmodule Day4Test do
  use ExUnit.Case, async: true

  @moduletag timeout: 5 * 60 * 1000

  test "count_houses" do
    assert 609043 == Day4.mine("abcdef")
    assert 1048970 == Day4.mine("pqrstuv")
  end

  test "input" do
    IO.puts Day4.mine("ckczppom")
  end
end
