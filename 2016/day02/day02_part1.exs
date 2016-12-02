defmodule Day02 do

  def button(moves), do: button(moves, 5)

  def button("", current), do: current
  def button("R" <> rest, current) when rem(current, 3) == 0, do: button(rest, current)
  def button("R" <> rest, current), do: button(rest, current + 1)
  def button("L" <> rest, current) when rem(current, 3) == 1, do: button(rest, current)
  def button("L" <> rest, current), do: button(rest, current - 1)
  def button("U" <> rest, current) when current > 3, do: button(rest, current - 3)
  def button("U" <> rest, current), do: button(rest, current)
  def button("D" <> rest, current) when current < 7, do: button(rest, current  + 3)
  def button("D" <> rest, current), do: button(rest, current)

end

# => 1985
# IO.puts Day02.button("ULL")
# IO.puts Day02.button("RRDDD", 1)
# IO.puts Day02.button("LURDL", 9)
# IO.puts Day02.button("UUUUD", 8)

File.stream!("input.txt")
|> Enum.reduce({"", 5}, fn (moves, {code, previous}) ->
  next = Day02.button(String.strip(moves), previous)
  {"#{code}#{next}", next}
end)
|> elem(0)
|> IO.puts
