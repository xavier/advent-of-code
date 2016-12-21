defmodule Day21 do

  def transform(password, instruction) do
    case String.split(instruction) do
      ["move", "position", src, "to", "position", dest] ->
        move(password, String.to_integer(src), String.to_integer(dest))
      ["swap", "position", pos1, "with", "position", pos2] ->
        swap_position(password, String.to_integer(pos1), String.to_integer(pos2))
      ["swap", "letter", letter, "with", "letter", other_letter] ->
        swap_letter(password, letter, other_letter)
      ["rotate", "right", steps, _] ->
        rotate_right(password, String.to_integer(steps))
      ["rotate", "left", steps, _] ->
        rotate_left(password, String.to_integer(steps))
      ["rotate", "based", "on", "position", "of", "letter", letter] ->
        rotate_position(password, letter)
      ["reverse", "positions", start, "through", stop] ->
        reverse(password, String.to_integer(start), String.to_integer(stop))
    end
  end

  def move(string, src, dest) do
    letters = String.codepoints(string)
    letter = Enum.at(letters, src)
    letters
    |> List.delete_at(src)
    |> List.insert_at(dest, letter)
    |> Enum.join
  end

  def swap_position(string, pos, pos), do: string
  def swap_position(string, pos1, pos2) when pos1 > pos2, do: swap_position(string, pos2, pos1)
  def swap_position(string, pos1, pos2) do
    {prefix, <<letter1>> <> rest} = String.split_at(string, pos1)
    {middle, <<letter2>> <> suffix} = String.split_at(rest, pos2 - pos1 - 1)
    prefix <> <<letter2>> <> middle <> <<letter1>> <> suffix
  end

  def swap_letter(string, letter, other) do
    do_swap_letter(string, letter, other, "")
  end
  defp do_swap_letter("", _, _, acc), do: acc
  defp do_swap_letter(<<letter>> <> string, <<letter>>, other, acc) do
    do_swap_letter(string, <<letter>>, other, acc <> other)
  end
  defp do_swap_letter(<<other>> <> string, letter, <<other>>, acc) do
    do_swap_letter(string, letter, <<other>>, acc <> letter)
  end
  defp do_swap_letter(<<no_swap>> <> string, letter, other, acc) do
    do_swap_letter(string, letter, other, acc <> <<no_swap>>)
  end

  def rotate_position(string, letter) do
    index = letter_index(string, letter)
    steps = if index < 4 do index + 1 else index + 2 end
    rotate_right(string, steps)
  end

  def rotate_right(string, steps) do
    len = String.length(string)
    steps = rem(steps, len)
    {shifted, carry} = String.split_at(string, len - steps)
    carry <> shifted
  end

  def rotate_left(string, steps) do
    steps = rem(steps, String.length(string))
    {carry, shifted} = String.split_at(string, steps)
    shifted <> carry
  end

  def reverse(string, start, stop) do
    prefix   = String.slice(string, 0, start)
    reversed = String.reverse(String.slice(string, start..stop))
    suffix   = String.slice(string, (stop + 1)..-1)
    prefix <> reversed <> suffix
  end

  def letter_index(string, letter), do: find_letter_index(string, letter, 0)
  defp find_letter_index("", _, _), do: nil
  defp find_letter_index(<<letter>> <> _, <<letter>>, index), do: index
  defp find_letter_index(<<_>> <> rest, letter, index), do: find_letter_index(rest, letter, index + 1)

end

# "abcde"
# |> IO.inspect
# |> Day21.swap_position(4, 0)
# |> IO.inspect
# |> Day21.swap_letter("d", "b")
# |> IO.inspect
# |> Day21.reverse(0, 4)
# |> IO.inspect
# |> Day21.rotate_left(1)
# |> IO.inspect
# |> Day21.move(1, 4)
# |> IO.inspect
# |> Day21.move(3, 0)
# |> IO.inspect
# |> Day21.rotate_position("b")
# |> IO.inspect
# |> Day21.rotate_position("d")
# |> IO.inspect

password = "abcdefgh"

File.stream!("input.txt")
|> Enum.reduce(password, fn (instruction, password) ->
  Day21.transform(password, instruction)
end)
|> IO.inspect
