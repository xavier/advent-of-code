defmodule Day14 do

  def keys(seed) do
    seed
    |> digest_stream
    |> Stream.map(fn ({index, digest}) -> {index, digest, find_triplet(digest)} end)
    |> Stream.filter(fn ({_, _, char}) -> char != nil end)
    |> Stream.filter_map(
      fn ({index, _, char}) ->
        confirm_candidate(seed, char, index + 1) end,
      fn ({index, key, _}) -> {index, key} end)
  end

  def confirm_candidate(seed, char, start_index) do
    target = String.duplicate(char, 5)
    seed
    |> digest_stream(start_index)
    |> Enum.take(1000)
    |> Enum.find(fn {_, digest} -> String.contains?(digest, target) end)
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

  defp digest_stream(seed, start_index \\ 0) do
    start_index
    |> Stream.iterate(fn n -> n + 1 end)
    |> Stream.map(fn index -> {index, md5("#{seed}#{index}")} end)
  end

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

