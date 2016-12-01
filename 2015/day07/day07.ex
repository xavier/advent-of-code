defmodule Day7 do
  @moduledoc """

  --- Day 7: Some Assembly Required ---

  This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates!
  Unfortunately, little Bobby is a little under the recommended age range, and he
  needs help assembling the circuit.

  Each wire has an identifier (some lowercase letters) and can carry a 16-bit
  signal (a number from 0 to 65535). A signal is provided to each wire by a
  gate, another wire, or some specific value. Each wire can only get a signal
  from one source, but can provide its signal to multiple destinations. A gate
  provides no signal until all of its inputs have a signal.

  The included instructions booklet describes how to connect the parts
  together: x AND y -> z means to connect wires x and y to an AND gate,
  and then connect its output to wire z.

  For example:

  - 123 -> x means that the signal 123 is provided to wire x.
  - x AND y -> z means that the bitwise AND of wire x and wire y is provided
    to wire z.
  - p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and
    then provided to wire q.
  - NOT e -> f means that the bitwise complement of the value from wire e is
    provided to wire f.

  Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to emulate the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide operators for these gates.

  For example, here is a simple circuit:

    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i

  After it is run, these are the signals on the wires:

    d: 72
    e: 507
    f: 492
    g: 114
    h: 65412
    i: 65079
    x: 123
    y: 456

      In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?

  """

  require Bitwise

  def new_circuit do
    %{}
  end

  def parse(line, circuit) do
    case tokenize(line) do
      [src, "->", dest] ->
        Dict.put(circuit, dest, {:=, parse_operand(src)})
      ["NOT", src, "->", dest] ->
        Dict.put(circuit, dest, {:not, parse_operand(src)})
      [arg1, "AND", arg2, "->", dest] ->
        Dict.put(circuit, dest, {:and, parse_operand(arg1), parse_operand(arg2)})
      [arg1, "OR", arg2, "->", dest] ->
        Dict.put(circuit, dest, {:or, parse_operand(arg1), parse_operand(arg2)})
      [arg1, "RSHIFT", arg2, "->", dest] ->
        Dict.put(circuit, dest, {:rshift, parse_operand(arg1), parse_operand(arg2)})
      [arg1, "LSHIFT", arg2, "->", dest] ->
        Dict.put(circuit, dest, {:lshift, parse_operand(arg1), parse_operand(arg2)})
      _ ->
        raise "Parse error: #{line}"
    end
  end

  defp tokenize(line), do: line |> String.strip |> String.split

  def parse_operand(string) do
    case Integer.parse(string) do
      {value, _} ->
        {:value, value}
      :error ->
        {:wire, string}
    end
  end

  def value_of(circuit, wire) do
    value_of(circuit, wire, %{}) |> elem(0)
  end

  def value_of(circuit, wire, env) do
    case Dict.get(env, wire) do
      nil ->
        {value, env} = Dict.fetch!(circuit, wire) |> eval(circuit, env)
        {value, Dict.put_new(env, wire, value)}
      value ->
        {value, env}
    end
  end

  def eval({:value, value}, _circuit, env), do: {value, env}
  def eval({:wire, wire}, circuit, env), do: value_of(circuit, wire, env)
  def eval({:=, operand}, circuit, env), do: eval(operand, circuit, env)
  def eval({:not, operand1}, circuit, env) do
    {value, env} = eval(operand1, circuit, env)
    {bnot16(value), env}
  end
  def eval({:and, operand1, operand2}, circuit, env) do
    {value1, env} = eval(operand1, circuit, env)
    {value2, env} = eval(operand2, circuit, env)
    {band16(value1, value2), env}
  end
  def eval({:or, operand1, operand2}, circuit, env) do
    {value1, env} = eval(operand1, circuit, env)
    {value2, env} = eval(operand2, circuit, env)
    {bor16(value1, value2), env}
  end
  def eval({:rshift, operand1, operand2}, circuit, env) do
    {value1, env} = eval(operand1, circuit, env)
    {value2, env} = eval(operand2, circuit, env)
    {bsr16(value1, value2), env}
  end
  def eval({:lshift, operand1, operand2}, circuit, env) do
    {value1, env} = eval(operand1, circuit, env)
    {value2, env} = eval(operand2, circuit, env)
    {bsl16(value1, value2), env}
  end

  defp bnot16(x),    do: Bitwise.bnot(x)    |> clip16
  defp band16(x, y), do: Bitwise.band(x, y) |> clip16
  defp bor16(x, y),  do: Bitwise.bor(x, y)  |> clip16
  defp bsl16(x, y),  do: Bitwise.bsl(x, y)  |> clip16
  defp bsr16(x, y),  do: Bitwise.bsr(x, y)  |> clip16

  defp clip16(x),    do: Bitwise.band(x, 0xffff)

end


ExUnit.start

defmodule Day7Test do
  use ExUnit.Case, async: true

  test "simple" do
    instructions = [
     "123 -> x",
     "456 -> y",
     "x AND y -> d",
     "x OR y -> e",
     "x LSHIFT 2 -> f",
     "y RSHIFT 2 -> g",
     "NOT x -> h",
     "NOT y -> i"
    ]

    circuit =
      instructions
      |> Enum.reduce(Day7.new_circuit, &Day7.parse/2)

    assert 72 == Day7.value_of(circuit, "d")
    assert 507 == Day7.value_of(circuit, "e")
    assert 492 == Day7.value_of(circuit, "f")
    assert 114 == Day7.value_of(circuit, "g")
    assert 65412 == Day7.value_of(circuit, "h")
    assert 65079 == Day7.value_of(circuit, "i")
    assert 123 == Day7.value_of(circuit, "x")
    assert 456 == Day7.value_of(circuit, "y")

  end

  test "input part 1" do
    File.stream!("day07.txt")
    |> Enum.reduce(Day7.new_circuit, &Day7.parse/2)
    |> Day7.value_of("a")
    |> IO.puts
  end

  test "part 2" do

    original_circuit =
      File.stream!("day07.txt")
      |> Enum.reduce(Day7.new_circuit, &Day7.parse/2)

    signal_from_a = Day7.value_of(original_circuit, "a")

    new_value_of_a =
      Dict.put(original_circuit, "b", {:value, signal_from_a})
      |> Day7.value_of("a")

    IO.puts "new value of a = #{new_value_of_a}"

  end
end
