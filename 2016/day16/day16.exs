defmodule Day16 do

  def fill(input, size) when byte_size(input) < size do
    input |> generate |> fill(size)
  end
  def fill(input, size) do
    input |> String.slice(0, size)
  end

  defp generate(input) do
    input <> "0" <> transform(input)
  end

  defp transform(input) do
    input
    |> String.reverse
    |> swap
  end

  defp swap(input), do: swap(input, "")
  defp swap("", acc), do: acc
  defp swap("0" <> rest, acc), do: swap(rest, acc <> "1")
  defp swap("1" <> rest, acc), do: swap(rest, acc <> "0")

  def checksum(data) do
    sum = sum_pairs(data)
    if rem(byte_size(sum), 2) == 0 do
      checksum(sum)
    else
      sum
    end
  end

  defp sum_pairs(data), do: sum_pairs(data, "")
  defp sum_pairs("", sum), do: sum
  defp sum_pairs(<<same::utf8, same::utf8>> <> rest, sum), do: sum_pairs(rest, sum <> "1")
  defp sum_pairs(<<_::utf8, _::utf8>> <> rest, sum), do: sum_pairs(rest, sum <> "0")

end

# Part 1
Day16.fill("01000100010010111", 272)
|> Day16.checksum
|> IO.puts

# Part 2
Day16.fill("01000100010010111", 35651584)
|> Day16.checksum
|> IO.puts
