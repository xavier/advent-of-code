defmodule Triangle do

  def possible?(a, b, c) do
    ((a + b) > c) && ((a + c) > b) && ((b + c) > a)
  end

end

File.stream!("input.txt")
|> Enum.map(fn (line) ->
  String.split(line) |> Enum.map(&String.to_integer/1)
end)
|> Enum.chunk(3)
|> Enum.flat_map(fn ([[a1, a2, a3], [b1, b2, b3], [c1, c2, c3]]) ->
  [[a1, b1, c1], [a2, b2, c2], [a3, b3, c3]]
end)
|> Enum.count(fn ([a, b, c]) -> Triangle.possible?(a, b, c) end)
|> IO.puts
