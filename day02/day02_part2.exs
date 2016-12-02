defmodule Day02 do

  def button(moves, start) when is_binary(moves) do
    moves |> String.codepoints |> button(start)
  end
  def button(moves, start), do: next_button(moves, start)

  @valid_moves %{
    1 => %{
      "D" => 3
    },
    2 => %{
      "R" => 3,
      "D" => 6,
    },
    3 => %{
      "L" => 2,
      "R" => 4,
      "U" => 1,
      "D" => 7
    },
    4 => %{
      "L" => 3,
      "D" => 8
    },
    5 => %{
      "R" => 6
    },
    6 => %{
      "L" => 5,
      "R" => 7,
      "U" => 2,
      "D" => "A"
    },
    7 => %{
      "L" => 6,
      "R" => 8,
      "U" => 3,
      "D" => "B"
    },
    8 => %{
      "L" => 7,
      "R" => 9,
      "U" => 4,
      "D" => "C"
    },
    9 => %{
      "L" => 8,
    },
    "A" => %{
      "R" => "B",
      "U" => 6,
    },
    "B" => %{
      "R" => "C",
      "L" => "A",
      "U" => 7,
      "D" => "D",
    },
    "C" => %{
      "L" => "B",
      "U" => 8,
    },
    "D" => %{
      "U" => "B",
    }
  }

  defp next_button([], current), do: current
  defp next_button([move|rest], current) do
    next =
      @valid_moves
      |> Map.fetch!(current)
      |> Map.get(move, current)

    next_button(rest, next)
  end

end

# => 5DB3
# IO.puts Day02.button("ULL", 5)
# IO.puts Day02.button("RRDDD", 5)
# IO.puts Day02.button("LURDL", "D")
# IO.puts Day02.button("UUUUD", "B")

File.stream!("input.txt")
|> Enum.reduce({"", 5}, fn (moves, {code, previous}) ->
  next = Day02.button(String.strip(moves), previous)
  {"#{code}#{next}", next}
end)
|> elem(0)
|> IO.puts
