defmodule Day05 do

  def md5(data) do
    :crypto.hash(:md5, data) |> Base.encode16
  end

  def guess_letter(input, position) do
    Stream.iterate(0, fn n -> n + 1 end)
    |> Stream.map(fn index -> md5("#{input}#{index}") end)
    |> Enum.find(fn hash -> String.starts_with?(hash, "00000#{position}") end)
    |> String.at(6)
  end

  def guess_password(input) do
    0..7
    |> pmap(fn (position) -> guess_letter(input, position) end)
  end

   defp pmap(collection, fun) do
    collection
    |> Enum.map(&(Task.async(fn -> fun.(&1) end)))
    |> Enum.map(&Task.await(&1, 20*60*1000))
    |> Enum.join
  end

end

#IO.inspect Day05.guess_letter("abc", 1)

IO.inspect Day05.guess_password("reyedfim")
