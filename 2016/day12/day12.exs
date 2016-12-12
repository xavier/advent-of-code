  defmodule Day12 do

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

  def initial_state(:part1) do
    %{ "pc" => 0, "a" => 0, "b" => 0, "c" => 0, "d" => 0 }
  end
  def initial_state(:part2) do
    %{ "pc" => 0, "a" => 0, "b" => 0, "c" => 1, "d" => 0 }
  end

  def run(program, state = %{"pc" => pc}) when pc >= 0 do
    case Enum.at(program, pc) do
    nil ->
      state
    next_instruction ->
      run(program, execute(next_instruction, state))
    end
  end

  defp execute(instruction, state) do
    # IO.puts ""
    # IO.puts "#{state["pc"]} #{inspect(instruction)}"
    state
    #|> IO.inspect
    |> execute_opcode(instruction)
    #|> IO.inspect
  end

  @registers ["a", "b", "c", "d"]

  defp execute_opcode(state, ["cpy", src, dst]) when src in @registers and dst in @registers do
    state
    |> Map.put(dst, Map.fetch!(state, src))
    |> advance_pc
  end
  defp execute_opcode(state, ["cpy", src, dst]) when is_integer(src) and dst in @registers do
    state
    |> Map.put(dst, src)
    |> advance_pc
  end
  defp execute_opcode(state, ["inc", reg]) when reg in @registers do
    state
    |> Map.update!(reg, fn (val) -> val + 1 end)
    |> advance_pc
  end
  defp execute_opcode(state, ["dec", reg]) when reg in @registers do
    state
    |> Map.update!(reg, fn (val) -> val - 1 end)
    |> advance_pc
  end
  defp execute_opcode(state, ["jnz", 0, _]), do: state |> advance_pc
  defp execute_opcode(state, ["jnz", val, offset]) when is_integer(val), do: jump(state, offset)
  defp execute_opcode(state, ["jnz", reg, offset]) when reg in @registers do
    case state do
      %{^reg => 0} ->
        #IO.puts "reg #{reg} = 0, advance"
        state |> advance_pc
      _ ->
        #IO.puts "reg #{reg} != 0, jump #{offset}"
        state |> jump(offset)
    end
  end

  defp advance_pc(state) do
    jump(state, 1)
  end

  defp jump(state = %{"pc" => pc}, offset) do
    %{state | "pc" => (pc + offset)}
  end

end

program =
  File.read!("input.txt")
  |> Day12.parse

program
|> Day12.run(Day12.initial_state(:part1))
|> IO.inspect

program
|> Day12.run(Day12.initial_state(:part2))
|> IO.inspect
