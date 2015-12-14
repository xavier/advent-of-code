defmodule Day14 do
  @moduledoc """

  --- Day 14: Reindeer Olympics ---

  This year is the Reindeer Olympics! Reindeer can fly at high speeds, but must
  rest occasionally to recover their energy. Santa would like to know which of
  his reindeer is fastest, and so he has them race.

  Reindeer can only either be flying (always at their top speed) or resting
  (not moving at all), and always spend whole seconds in either state.

  For example, suppose you have the following Reindeer:

  - Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
  - Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
  - After one second, Comet has gone 14 km, while Dancer has gone 16 km.
  - After ten seconds, Comet has gone 140 km, while Dancer has gone 160 km.
  - On the eleventh second, Comet begins resting (staying at 140 km), and
    Dancer continues on for a total distance of 176 km. On the 12th second,
    both reindeer are resting. They continue to rest until the 138th second,
    when Comet flies for another ten seconds. On the 174th second, Dancer
    flies for another 11 seconds.

  In this example, after the 1000th second, both reindeer are resting, and Comet
  is in the lead at 1120 km (poor Dancer has only gotten 1056 km by that point).

  So, in this situation, Comet would win (if the race ended at 1000 seconds).

  Given the descriptions of each reindeer (in your puzzle input), after
  exactly 2503 seconds, what distance has the winning reindeer traveled?


  """

  @regex_line ~r/^(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\.$/

  def parse(line) do
    case Regex.run(@regex_line, line) do
      [_, name, speed, fly_time, rest_time] ->
        {name, to_int(speed), to_int(fly_time), to_int(rest_time)}
    end
  end

  defp to_int(string), do: Integer.parse(string) |> elem(0)

  # def fly({_, speed, fly_time, rest_time}, duration) do
  #   case div(duration, fly_time + rest_time) do
  #     0 ->
  #       speed * duration
  #     full_cycles ->
  #       IO.puts "#{speed} * #{fly_time} * {full_cycles}"
  #       speed * fly_time * full_cycles
  #   end
  # end

  def fly(_, duration) when duration < 0, do: 0
  def fly({_, speed, fly_time, _}, duration) when duration <= fly_time, do: speed * duration
  def fly({name, speed, fly_time, rest_time}, duration) do
    speed * fly_time + fly({name, speed, fly_time, rest_time}, duration - fly_time - rest_time)
  end

end


ExUnit.start

defmodule Day14Test do
  use ExUnit.Case, async: true

  test "parse" do
    assert {"Comet", 14, 10, 127} == Day14.parse("Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.")
  end

  test "fly" do
    comet  = {"Comet", 14, 10, 127}
    dancer = {"Dancer", 16, 11, 162}

    assert 14 == Day14.fly(comet, 1)
    assert 16 == Day14.fly(dancer, 1)

    assert 140 == Day14.fly(comet, 10)
    assert 160 == Day14.fly(dancer, 10)

    assert 140 == Day14.fly(comet, 11)
    assert 176 == Day14.fly(dancer, 11)

    assert 140 == Day14.fly(comet, 12)
    assert 176 == Day14.fly(dancer, 12)

    assert 154 == Day14.fly(comet, 138)
    assert 192 == Day14.fly(dancer, 174)

    assert 1120 == Day14.fly(comet, 1000)
    assert 1056 == Day14.fly(dancer, 1000)
  end


  test "input 1" do
    IO.puts "input 1"
    File.stream!("day14.txt")
    |> Enum.map(&Day14.parse/1)
    |> Enum.map(fn (reinder = {name, _, _, _}) -> {name, Day14.fly(reinder, 2503)} end)
    |> Enum.max_by(fn ({_, dist}) -> dist end)
    |> IO.inspect
  end

end
