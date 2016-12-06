File.stream!("input.txt")
|> Enum.map(fn (line) -> line |> String.trim |> String.codepoints end)
|> Enum.reduce(%{}, fn (letters, acc) ->
  Enum.reduce(letters, {acc, 0}, fn (letter, {acc, position}) ->
    new_acc = Map.update(acc, position, %{letter => 0}, fn (counters) ->
      Map.update(counters, letter, 0, fn count -> count + 1 end)
    end)
    {new_acc, position + 1}
  end)
  |> elem(0)
end)
|> Enum.map(fn {_, counters} ->
  [{letter, _} | _] = Enum.sort_by(counters, fn {_, count} -> count end)
  letter
end)
|> Enum.join
|> IO.puts
