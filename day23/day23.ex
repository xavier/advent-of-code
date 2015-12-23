defmodule Day23 do
  @moduledoc """
  --- Day 23: Opening the Turing Lock ---

  Little Jane Marie just got her very first computer for
  Christmas from some unknown benefactor. It comes with
  instructions and an example program, but the computer
  itself seems to be malfunctioning. She's curious what
  the program does, and would like you to help her run it.

  The manual explains that the computer supports two
  registers and six instructions (truly, it goes on
  to remind the reader, a state-of-the-art technology).
  The registers are named a and b, can hold any non-negative i
  nteger, and begin with a value of 0. The instructions are
  as follows:

  - hlf r sets register r to half its current value,
    then continues with the next instruction.
  - tpl r sets register r to triple its current value,
    then continues with the next instruction.
  - inc r increments register r, adding 1 to it,
    then continues with the next instruction.
  - jmp offset is a jump; it continues with the instruction
    offset away relative to itself.
  - jie r, offset is like jmp, but only jumps if register r is even
    ("jump if even").
  - jio r, offset is like jmp, but only jumps if register r is 1
    ("jump if one", not odd).

  All three jump instructions work with an offset relative to
  that instruction. The offset is always written with a
  prefix + or - to indicate the direction of the jump
  (forward or backward, respectively). For example,
  jmp +1 would simply continue with the next instruction,
  while jmp +0 would continuously jump back to itself forever.

  The program exits when it tries to run an instruction
  beyond the ones defined.

  For example, this program sets a to 2, because the jio
  instruction causes it to skip the tpl instruction:

  inc a
  jio a, +2
  tpl a
  inc a

  What is the value in register b when the program in your puzzle input is finished executing?
  """

  defmodule State do
    defstruct regs: %{"a" => 0, "b" => 0}, pc: 0
  end

  def parse(source) do
    source
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    case String.split(line, ~r/[\s\,]+/) do
      ["hlf", reg] ->
        {:hlf, reg}
      ["tpl", reg] ->
        {:tpl, reg}
      ["inc", reg] ->
        {:inc, reg}
      ["jmp", offset] ->
        {:jmp, to_int(offset)}
      ["jie", reg, offset] ->
        {:jie, reg, to_int(offset)}
      ["jio", reg, offset] ->
        {:jio, reg, to_int(offset)}
    end
  end

  defp to_int(s), do: s |> Integer.parse |> elem(0)

  def run(program) do
    run(program, %State{})
  end

  def run(program, state = %State{pc: pc}) when pc >= length(program), do: state
  def run(program, state) do
    new_state =
      program
      |> Enum.at(state.pc)
      |> execute_instruction(state)

    run(program, new_state)
  end

  def execute_instruction({:hlf, reg}, state) do
    state
    |> set_reg(reg, div(get_reg(state, reg), 2))
    |> inc_pc
  end
  def execute_instruction({:tpl, reg}, state) do
    state
    |> set_reg(reg, get_reg(state, reg) * 3)
    |> inc_pc
  end
  def execute_instruction({:inc, reg}, state) do
    state
    |> set_reg(reg, get_reg(state, reg) + 1)
    |> inc_pc
  end
  def execute_instruction({:jmp, offset}, state) do
    state |> advance_pc(offset)
  end
  def execute_instruction({:jie, reg, offset}, state) do
    cond do
      rem(get_reg(state, reg), 2) == 0 ->
        state |> advance_pc(offset)
      true ->
        state |> inc_pc
    end
  end
  def execute_instruction({:jio, reg, offset}, state) do
    case get_reg(state, reg) do
      1 ->
        state |> advance_pc(offset)
      _ ->
        state |> inc_pc
    end
  end

  defp get_reg(state, reg) do
    {:ok, val} = Dict.fetch(state.regs, reg)
    val
  end

  defp set_reg(state, reg, value) do
    %State{state | regs: Dict.put(state.regs, reg, value)}
  end

  defp inc_pc(state), do: advance_pc(state, 1)

  defp advance_pc(state, offset) do
    %State{state | pc: state.pc + offset}
  end

end

ExUnit.start

defmodule Day23Test do
  use ExUnit.Case, async: true

  test "example" do
    source = "inc a\njio a, +2\ntpl a\ninc a"

    final_state =
      source
      |> Day23.parse
      |> Day23.run

    assert 2 == Dict.get(final_state.regs, "a")
  end

  test "part 1" do
    IO.puts "part 1"
    File.read!("day23.txt")
    |> Day23.parse
    |> Day23.run
    |> IO.inspect
  end
end

