  defmodule Day25 do

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

  def initial_state(program, a) do
    {program, %{ "pc" => 0, "a" => a, "b" => 0, "c" => 0, "d" => 0, "ck" => 1 }}
  end

  def run(state = {_, %{"ck" => :invalid}}), do: state
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
  defp execute({program, regs = %{"ck" => ck}}, ["out", reg]) do
    new_ck =
      case {ck, Map.fetch!(regs, reg)} do
        {0, 1} ->
          1
        {1, 0} ->
          0
        _ ->
          :invalid
      end
    {program, %{regs | "ck" => new_ck} |> advance_pc}
  end

  defp advance_pc(regs) do
    jump(regs, 1)
  end

  defp jump(regs = %{"pc" => pc}, offset) do
    %{regs | "pc" => (pc + offset)}
  end

end

# Part 1
program = File.read!("input.txt") |> Day25.parse

Stream.iterate(0, fn n -> n + 1 end)
|> Enum.each(fn n ->
  IO.puts "Trying #{n}"
  program |> Day25.initial_state(n) |> Day25.run |> IO.inspect
end)
