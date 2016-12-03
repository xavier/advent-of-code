defmodule Triangle do

  def possible?(a, b, c) do
    ((a + b) > c) && ((a + c) > b) && ((b + c) > a)
  end

end

File.stream!("input.txt")
|> Enum.map(fn (line) ->
  String.split(line) |> Enum.map(&String.to_integer/1)
end)
|> Enum.count(fn ([a, b, c]) -> Triangle.possible?(a, b, c) end)
|> IO.puts
