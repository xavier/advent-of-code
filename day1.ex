defmodule Day1 do
  @moduledoc """
  --- Day 1: Not Quite Lisp ---

  Santa is trying to deliver presents in a large apartment building,
  but he can't find the right floor - the directions he got are a
  little confusing. He starts on the ground floor (floor 0) and
  then follows the instructions one character at a time.

  An opening parenthesis, (, means he should go up one floor,
  and a closing parenthesis, ), means he should go down one floor.

  The apartment building is very tall, and the basement is very deep;
  he will never find the top or bottom floors.

  For example:

  (()) and ()() both result in floor 0.
  ((( and (()(()( both result in floor 3.
  ))((((( also results in floor 3.
  ()) and ))( both result in floor -1 (the first basement level).
  ))) and )())()) both result in floor -3.

  To what floor do the instructions take Santa?

  """

  def floor(instructions), do: step(instructions, 0)

  defp step("", floor), do: floor
  defp step("(" <> instructions, floor), do: step(instructions, floor + 1)
  defp step(")" <> instructions, floor), do: step(instructions, floor - 1)

  def basement(instructions), do: step_basement(instructions, 0, 1)

  defp step_basement("", _, _), do: 0
  defp step_basement(")" <> _, 0, position), do: position
  defp step_basement("(" <> instructions, floor, position), do: step_basement(instructions, floor + 1, position + 1)
  defp step_basement(")" <> instructions, floor, position), do: step_basement(instructions, floor - 1, position + 1)

end


ExUnit.start

defmodule Day1Test do
  use ExUnit.Case, async: true

  test "floor" do
    assert 0 == Day1.floor("(())")
    assert 0 == Day1.floor("()()")

    assert 3 == Day1.floor("(((")
    assert 3 == Day1.floor("(()(()(")
    assert 3 == Day1.floor("))(((((")

    assert -1 == Day1.floor("())")
    assert -1 == Day1.floor("))(")

    assert -3 == Day1.floor(")))")
    assert -3 == Day1.floor(")())())")
  end

  test "basement" do
    assert 1 == Day1.basement(")")
    assert 5 == Day1.basement("()())")
  end

  test "input floor" do
    IO.puts "floor"
    File.read!("day1.txt")
    |> Day1.floor
    |> IO.puts
  end

  test "input basement" do
    IO.puts "basement"
    File.read!("day1.txt")
    |> Day1.basement
    |> IO.puts
  end
end
