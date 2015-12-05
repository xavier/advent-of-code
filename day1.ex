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

  defp step("", acc), do: acc
  defp step("(" <> instructions, acc), do: step(instructions, acc + 1)
  defp step(")" <> instructions, acc), do: step(instructions, acc - 1)

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
end
