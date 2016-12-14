defmodule Day14 do

  def keys(seed) do
    seed
    |> digest_stream
    |> Stream.chunk(1000, 1)
    |> Stream.map(fn (chunk = [{_, digest}|_]) -> {chunk, find_triplet(digest)} end)
    |> Stream.filter(fn ({_, char}) -> char != nil end)
    |> Stream.filter_map(
      fn ({[_|others], char}) -> confirm_candidate(char, others) end,
      fn ({[good_key|_], _}) -> good_key end)
  end

  def confirm_candidate(char, others) do
    target = String.duplicate(char, 5)
    Enum.find(others, fn {_, digest} -> String.contains?(digest, target) end)
  end

  @triplet_regex ~r/(.)\1{2}/

  def find_triplet(string) do
    case Regex.run(@triplet_regex, string, capture: :first) do
      [match] ->
        String.at(match, 0)
      _ ->
        nil
    end
  end

  def digest_stream(seed, start_index \\ 0) do
    start_index
    |> Stream.iterate(fn n -> n + 1 end)
    |> Stream.map(fn index -> {index, stretch(md5("#{seed}#{index}"), 2016)} end)
  end

  defp stretch(key, 0), do: key
  defp stretch(key, rounds), do: key |> md5 |> stretch(rounds - 1)

  defp md5(data) do
    :crypto.hash(:md5, data) |> Base.encode16(case: :lower)
  end
end

seed = "jlmsuwbz"

seed
|> Day14.keys
|> Enum.take(64)
|> Enum.reverse
|> Enum.at(0)
|> IO.inspect

