defmodule Day19 do
  @moduledoc """

  --- Day 19: Medicine for Rudolph ---

  Rudolph the Red-Nosed Reindeer is sick! His nose isn't shining very brightly,
  and he needs medicine.

  Red-Nosed Reindeer biology isn't similar to regular reindeer biology; Rudolph
  is going to need custom-made medicine. Unfortunately, Red-Nosed Reindeer chemistry
  isn't similar to regular reindeer chemistry, either.

  The North Pole is equipped with a Red-Nosed Reindeer nuclear fusion/fission plant,
  capable of constructing any Red-Nosed Reindeer molecule you need. It works by
  starting with some input molecule and then doing a series of replacements, one per step,
  until it has the right molecule.

  However, the machine has to be calibrated before it can be used. Calibration involves
  determining the number of molecules that can be generated in one step from a given
  starting point.

  For example, imagine a simpler machine that supports only the following replacements:

  H => HO
  H => OH
  O => HH

  Given the replacements above and starting with HOH, the following molecules could be
  generated:

  HOOH (via H => HO on the first H).
  HOHO (via H => HO on the second H).
  OHOH (via H => OH on the first H).
  HOOH (via H => OH on the second H).
  HHHH (via O => HH).

  So, in the example above, there are 4 distinct molecules (not five, because HOOH appears
  twice) after one replacement from HOH. Santa's favorite molecule, HOHOHO, can become
  7 distinct molecules (over nine replacements: six from H, and three from O).

  The machine replaces without regard for the surrounding characters. For example, given
  the string H2O, the transition H => OO would result in OO2O.

  Your puzzle input describes all of the possible replacements and, at the bottom, the
  medicine molecule for which you need to calibrate the machine.
  How many distinct molecules can be created after all the different ways you can do
  one replacement on the medicine molecule?


  """

  @regex_line ~r/([A-Z][a-z]?) \=\> ([A-Z][A-Za-z]*)/

  def parse(text) do
    Regex.scan(@regex_line, text)
    |> Enum.reduce(%{}, fn ([_, k, v], dict) ->
      Dict.update(dict, k, [v], fn (list) -> [v|list] end)
    end)
  end

  def replacements(input, dict) do
    do_replacement(input, dict, "", [])
  end

  def do_replacement("", _, _, acc), do: acc
  def do_replacement(<<c1>>, dict, pfx, acc) do
    do_replacement_single_letter(<<c1>>, dict, pfx, acc)
  end
  def do_replacement(<<c1, c2>> <> str, dict, pfx, acc) do
    case Dict.get(dict, <<c1, c2>>) do
      nil ->
       do_replacement_single_letter(<<c1, c2>> <> str, dict, pfx, acc)
      list ->
        do_replacement(str, dict, pfx <> <<c1, c2>>, acc ++ Enum.map(list, fn (r) -> "#{pfx}#{r}#{str}" end))
    end
  end

  defp do_replacement_single_letter(<<c1>> <> str, dict, pfx, acc) do
    case Dict.get(dict, <<c1>>) do
      nil ->
        do_replacement(str, dict, pfx <> <<c1>>, acc)
      list ->
        do_replacement(str, dict, pfx <> <<c1>>, acc ++ Enum.map(list, fn (r) -> "#{pfx}#{r}#{str}" end))
    end
  end


end

ExUnit.start

defmodule Day19Test do
  use ExUnit.Case, async: true

  test "parse" do

    text = "H => HO\nH => OH\nO => HH"

    expected = %{
      "H" => ["OH", "HO"],
      "O" => ["HH"],
    }

    assert expected == Day19.parse(text)

  end

  test "replacements" do

    dict = %{
      "H" => ["OH", "HO"],
      "O" => ["HH"],
    }

    expected = [
      "HOOH", "HOHO", "OHOH", "HOOH", "HHHH"
    ] |> Enum.sort |> Enum.uniq

    result =
      Day19.replacements("HOH", dict)
      |> Enum.sort |> Enum.uniq

    assert expected == result
  end

  test "input 1" do

    [rules, input] =
      File.read!("day19.txt")
      |> String.split("\n\n")
      |> Enum.map(&String.strip/1)

    dict = Day19.parse(rules)

    input
    |> Day19.replacements(dict)
    |> Enum.uniq
    |> IO.inspect
    |> Enum.count
    |> IO.puts


  end

end
