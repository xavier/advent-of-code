defmodule Day13 do
  @moduledoc """
  --- Day 13: Knights of the Dinner Table ---

  In years past, the holiday feast with your family hasn't gone so well.
  Not everyone gets along! This year, you resolve, will be different.
  You're going to find the optimal seating arrangement and avoid all
  those awkward conversations.

  You start by writing up a list of everyone invited and the amount
  their happiness would increase or decrease if they were to find
  themselves sitting next to each other person. You have a circular
  table that will be just big enough to fit everyone comfortably,
  and so each person will have exactly two neighbors.

  For example, suppose you have only four attendees planned, and
  you calculate their potential happiness as follows:

  - Alice would gain 54 happiness units by sitting next to Bob.
  - Alice would lose 79 happiness units by sitting next to Carol.
  - Alice would lose 2 happiness units by sitting next to David.
  - Bob would gain 83 happiness units by sitting next to Alice.
  - Bob would lose 7 happiness units by sitting next to Carol.
  - Bob would lose 63 happiness units by sitting next to David.
  - Carol would lose 62 happiness units by sitting next to Alice.
  - Carol would gain 60 happiness units by sitting next to Bob.
  - Carol would gain 55 happiness units by sitting next to David.
  - David would gain 46 happiness units by sitting next to Alice.
  - David would lose 7 happiness units by sitting next to Bob.
  - David would gain 41 happiness units by sitting next to Carol.

  Then, if you seat Alice next to David, Alice would lose 2 happiness
  units (because David talks so much), but David would gain 46
  happiness units (because Alice is such a good listener), for a
  total change of 44.

  If you continue around the table, you could then seat Bob next to
  Alice (Bob gains 83, Alice gains 54). Finally, seat Carol, who
  sits next to Bob (Carol gains 60, Bob loses 7) and David (Carol
  gains 55, David gains 41). The arrangement looks like this:

       +41 +46
  +55   David    -2
  Carol       Alice
  +60    Bob    +54
       -7  +83

  After trying every other seating arrangement in this hypothetical
  scenario, you find that this one is the most optimal, with a total
  change in happiness of 330.

  What is the total change in happiness for the optimal seating
  arrangement of the actual guest list?

  --- Part Two ---

  In all the commotion, you realize that you forgot to seat yourself. At this point,
  you're pretty apathetic toward the whole thing, and your happiness wouldn't really
  go up or down regardless of who you sit next to. You assume everyone else would be
  just as ambivalent about sitting next to you, too.

  So, add yourself to the list, and give all happiness relationships that involve you
  a score of 0.

  What is the total change in happiness for the optimal seating arrangement that
  actually includes yourself?

  """

  @regex_line ~r/^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\.$/

  def parse(line) do
    case Regex.run(@regex_line, line) do
      [_, subject, "gain", units, other] ->
          {subject, other, to_int(units)}
      [_, subject, "lose", units, other] ->
          {subject, other, -to_int(units)}
    end
  end

  defp to_int(string), do: Integer.parse(string) |> elem(0)

  def build_definitions(definitions) do
    definitions
    |> Enum.reduce(
        HashDict.new,
        fn ({subject, other, gain}, graph) ->
          Dict.update(
            graph,
            subject,
            Dict.put(HashDict.new, other, gain),
            fn (dict) ->
              Dict.put(dict, other, gain)
            end)
        end)
  end

  def gain_between(definitions, subject, other), do: definitions |> Dict.get(subject) |> Dict.get(other)

  def total_gain(definitions, names = [first_name|_]) do
    Enum.chunk(names, 2, 1, [first_name])
    |> Enum.reduce(0, fn ([subject, other], acc) ->
      acc + gain_between(definitions, subject, other) + gain_between(definitions, other, subject)
    end)
  end

  def optimal_seating(definitions) do
    Dict.keys(definitions)
    |> permutations
    |> Enum.map(fn (names) -> {names, total_gain(definitions, names)} end)
    |> Enum.max_by(fn ({_, gain}) -> gain end)
  end

  def add_myself(definitions) do
    hash = (for name <- Dict.keys(definitions), into: HashDict.new, do: {name, 0})
    definitions
    |> Enum.into(HashDict.new, fn ({name, dict}) -> {name, Dict.put(dict, "Xavier", 0)} end)
    |> Dict.put("Xavier", hash)
  end

  defp permutations([]), do: [[]]
  defp permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h|t]
  end

end


ExUnit.start

defmodule Day13Test do
  use ExUnit.Case, async: true

  test "parse" do
    assert {"Alice", "Bob", 54} == Day13.parse("Alice would gain 54 happiness units by sitting next to Bob.")
    assert {"Alice", "Carol", -81} == Day13.parse("Alice would lose 81 happiness units by sitting next to Carol.")
  end

  test "optimal_seating" do
    definitions = [
      Day13.parse("Alice would gain 54 happiness units by sitting next to Bob."),
      Day13.parse("Alice would lose 79 happiness units by sitting next to Carol."),
      Day13.parse("Alice would lose 2 happiness units by sitting next to David."),
      Day13.parse("Bob would gain 83 happiness units by sitting next to Alice."),
      Day13.parse("Bob would lose 7 happiness units by sitting next to Carol."),
      Day13.parse("Bob would lose 63 happiness units by sitting next to David."),
      Day13.parse("Carol would lose 62 happiness units by sitting next to Alice."),
      Day13.parse("Carol would gain 60 happiness units by sitting next to Bob."),
      Day13.parse("Carol would gain 55 happiness units by sitting next to David."),
      Day13.parse("David would gain 46 happiness units by sitting next to Alice."),
      Day13.parse("David would lose 7 happiness units by sitting next to Bob."),
      Day13.parse("David would gain 41 happiness units by sitting next to Carol."),
    ]

    {_seating, total_change} =
      definitions
      |> Day13.build_definitions
      |> Day13.optimal_seating

    assert 330 == total_change

  end

  test "input 1" do
    IO.puts "input 1"
    File.stream!("day13.txt")
    |> Enum.map(&Day13.parse/1)
    |> Day13.build_definitions
    |> Day13.optimal_seating
    |> IO.inspect
  end

  test "input 2" do
    IO.puts "input 2"
    File.stream!("day13.txt")
    |> Enum.map(&Day13.parse/1)
    |> Day13.build_definitions
    |> Day13.add_myself
    |> Day13.optimal_seating
    |> IO.inspect
  end

end
