defmodule Day18 do

  def generate(first_row, total_rows) do
    1..(total_rows-1)
    |> Enum.reduce([first_row], fn (_, rows = [previous_row|_]) ->
      [next_row(previous_row) | rows]
    end)
    |> Enum.reverse
    |> Enum.join("\n")
  end

  @trap "^"
  @safe "."

  defp next_row(row) do
    "#{@safe}#{row}#{@safe}"
    |> String.codepoints
    |> Enum.chunk(3, 1)
    |> Enum.map(fn ([left, center, right]) -> new_tile(left, center, right) end)
    |> Enum.join
  end

  defp new_tile(@trap, @trap, @safe), do: @trap
  defp new_tile(@safe, @trap, @trap), do: @trap
  defp new_tile(@trap, @safe, @safe), do: @trap
  defp new_tile(@safe, @safe, @trap), do: @trap
  defp new_tile(_, _, _), do: @safe

end

# Example 1
#IO.puts Day18.generate("..^^.", 3)

# Example 2
#IO.puts Day18.generate(".^^.^.^^^^", 10)

# Part 1
input = ".^^^^^.^^^..^^^^^...^.^..^^^.^^....^.^...^^^...^^^^..^...^...^^.^.^.......^..^^...^.^.^^..^^^^^...^."
IO.puts Day18.generate(input, 40) |> String.codepoints |> Enum.count(fn (tile) -> tile == "." end)

# Part 2
IO.puts Day18.generate(input, 400_000) |> String.codepoints |> Enum.count(fn (tile) -> tile == "." end)
