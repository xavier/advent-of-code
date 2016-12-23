  defmodule Day23 do

  def parse(program) do
    program
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(line) do
    line
    |> String.split
    |> parse_direct_values
  end

  defp parse_direct_values(tokens) do
    Enum.map(tokens, fn (token) ->
      case Integer.parse(token) do
        {value, ""} ->
          value
        _ ->
          token
      end
    end)
  end

  def initial_state(program, :part1) do
    {program, %{ "pc" => 0, "a" => 7, "b" => 0, "c" => 0, "d" => 0 }}
  end
  def initial_state(program, :part2) do
    {program, %{ "pc" => 0, "a" => 12, "b" => 0, "c" => 0, "d" => 0 }}
  end

  def run(state = {program, %{"pc" => pc}}) when pc >= 0 do
    case Enum.at(program, pc) do
    nil ->
      state
    next_instruction ->
      run(execute(state, next_instruction))
    end
  end

  @registers ["a", "b", "c", "d"]

  defp execute({program, regs}, ["cpy", src, dst]) when src in @registers and dst in @registers do
    {program, regs |> Map.put(dst, Map.fetch!(regs, src)) |> advance_pc}
  end
  defp execute({program, regs}, ["cpy", src, dst]) when is_integer(src) and dst in @registers do
    {program, regs |> Map.put(dst, src) |> advance_pc}
  end
  defp execute({program, regs}, ["inc", reg]) when reg in @registers do
    {program, regs |> Map.update!(reg, fn (val) -> val + 1 end) |> advance_pc}
  end
  defp execute({program, regs}, ["dec", reg]) when reg in @registers do
    {program, regs |> Map.update!(reg, fn (val) -> val - 1 end) |> advance_pc}
  end
  defp execute({program, regs}, ["jnz", 0, _]), do: {program, regs |> advance_pc}
  defp execute({program, regs}, ["jnz", val, offset]) when is_integer(val) and is_integer(offset), do: {program, regs |> jump(offset)}
  defp execute({program, regs}, ["jnz", val, reg]) when reg in @registers do
    execute({program, regs}, ["jnz", val, Map.fetch!(regs, reg)])
  end
  defp execute({program, regs}, ["jnz", reg, offset]) when reg in @registers do
    case regs do
      %{^reg => 0} ->
        {program, regs |> advance_pc}
      _ ->
        {program, regs |> jump(offset)}
    end
  end
  defp execute({program, regs = %{"pc" => pc}}, ["tgl", reg]) do
    address = pc + Map.fetch!(regs, reg)
    {List.update_at(program, address, &toggle/1), regs |> advance_pc}
  end

  defp toggle(["inc", arg]), do: ["dec", arg]
  defp toggle([_, arg]), do: ["inc", arg]
  defp toggle(["jnz", arg1, arg2]), do: ["cpy", arg1, arg2]
  defp toggle([_, arg1, arg2]), do: ["jnz", arg1, arg2]

  defp advance_pc(regs) do
    jump(regs, 1)
  end

  defp jump(regs = %{"pc" => pc}, offset) do
    %{regs | "pc" => (pc + offset)}
  end

end

# test_program = [
#   ["cpy", 2, "a"],
#   ["tgl", "a"],
#   ["tgl", "a"],
#   ["tgl", "a"],
#   ["cpy", 1, "a"],
#   ["dec", "a"],
#   ["dec", "a"],
# ]

# test_program
# |> Day23.initial_state
# |> Day23.run
# |> IO.inspect


# Part 1
# File.read!("input.txt")
# |> Day23.parse
# |> Day23.initial_state(:part1)
# |> Day23.run
# |> elem(1)
# |> IO.inspect

# Part 2
File.read!("input.txt")
|> Day23.parse
|> Day23.initial_state(:part2)
|> Day23.run
|> elem(1)
|> IO.inspect
