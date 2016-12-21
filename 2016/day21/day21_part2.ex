defmodule Day21 do

  def reverse_transform(password, instruction) do
    case String.split(instruction) do
      ["move", "position", src, "to", "position", dest] ->
        move(password, String.to_integer(dest), String.to_integer(src))
      ["swap", "position", pos1, "with", "position", pos2] ->
        swap_position(password, String.to_integer(pos1), String.to_integer(pos2))
      ["swap", "letter", letter, "with", "letter", other_letter] ->
        swap_letter(password, letter, other_letter)
      ["rotate", "right", steps, _] ->
        rotate_left(password, String.to_integer(steps))
      ["rotate", "left", steps, _] ->
        rotate_right(password, String.to_integer(steps))
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

  @rotate_pos_shift %{
    0 => 1,
    1 => 2,
    2 => 3,
    3 => 4,
    4 => 6,
    5 => 7,
    6 => 8,
    7 => 9,
  }

  def rotate_position(string, letter) do
    index = letter_index(string, letter)
    steps = div(index, 2) + cond do
      rem(index, 2) == 1 -> 1
      index == 0 -> 1
      true -> 5
    end
    rotate_left(string, steps)
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

# Part 1 answer should generate "abcdefgh"
# password = "ghfacdbe"

password = "fbgdceah"
File.stream!("input.txt")
|> Enum.reverse
|> Enum.reduce(password, fn (instruction, password) ->
  Day21.reverse_transform(password, instruction)
end)
|> IO.inspect
