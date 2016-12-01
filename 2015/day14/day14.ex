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

  --- Part Two ---

  Seeing how reindeer move in bursts, Santa decides he's not pleased with the old scoring system.

  Instead, at the end of each second, he awards one point to the reindeer currently in the lead.
  (If there are multiple reindeer tied for the lead, they each get one point.) He keeps the
  traditional 2503 second time limit, of course, as doing otherwise would be entirely ridiculous.

  Given the example reindeer from above, after the first second, Dancer is in the lead and gets one
  point. He stays in the lead until several seconds into Comet's second burst: after the 140th second,
  Comet pulls into the lead and gets his first point. Of course, since Dancer had been in the lead for
  the 139 seconds before that, he has accumulated 139 points by the 140th second.

  After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only
  has 312. So, with the new scoring system, Dancer would win (if the race ended at 1000 seconds).

  Again given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds,
  how many points does the winning reindeer have?

  """

  @regex_line ~r/^(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\.$/

  def parse(line) do
    case Regex.run(@regex_line, line) do
      [_, name, speed, fly_time, rest_time] ->
        {name, to_int(speed), to_int(fly_time), to_int(rest_time)}
    end
  end

  defp to_int(string), do: Integer.parse(string) |> elem(0)

  def fly(_, duration) when duration < 0, do: 0
  def fly({_, speed, fly_time, _}, duration) when duration <= fly_time, do: speed * duration
  def fly({name, speed, fly_time, rest_time}, duration) do
    speed * fly_time + fly({name, speed, fly_time, rest_time}, duration - fly_time - rest_time)
  end

  def race(reindeers, duration) do
    (1..duration) |> Enum.reduce(initial_leaderboard(reindeers), fn (time, ldb) -> fly_race(ldb, time) end)
  end

  def initial_leaderboard(reindeers) do
    for {name, speed, fly_time, rest_time} <- reindeers, into: %{} do
      {name, {speed, fly_time, rest_time, 0, 0}}
    end
  end

  def fly_race(leaderboard, time) do
    sorted =
      leaderboard
      |> Enum.map(fn ({name, {speed, fly_time, rest_time, dist, points}}) ->
        {name, {speed, fly_time, rest_time, fly({name, speed, fly_time, rest_time}, time), points}}
      end)
      |> Enum.sort_by(fn ({_, {_, _, _, dist, _points}}) -> -dist end)

    [{_, {_, _, _, leading_distance, _}}|_] = sorted

    sorted
    |> Enum.into(leaderboard, fn ({name, {speed, fly_time, rest_time, dist, points}}) ->
      if dist == leading_distance do
        {name, {speed, fly_time, rest_time, dist, points + 1}}
      else
        {name, {speed, fly_time, rest_time, dist, points}}
      end
    end)
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

  test "initial_leaderboard" do

    comet  = {"Comet", 14, 10, 127}
    dancer = {"Dancer", 16, 11, 162}

    expected = %{
      "Comet" => {14, 10, 127, 0, 0},
      "Dancer" => {16, 11, 162, 0, 0}
    }

    assert expected == Day14.initial_leaderboard([comet, dancer])

  end

  test "fly_race" do

    leaderboard = %{
      "Comet" => {14, 10, 127, 0, 0},
      "Dancer" => {16, 11, 162, 0, 0}
    }

    expected = %{
      "Comet" => {14, 10, 127, 14, 0},
      "Dancer" => {16, 11, 162, 16, 1}
    }


    assert expected == Day14.fly_race(leaderboard, 1)

  end

  test "race" do

    #After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only
    #has 312. So, with the new scoring system, Dancer would win (if the race ended at 1000 seconds).

    reindeers = [
      {"Comet", 14, 10, 127},
      {"Dancer", 16, 11, 162}
    ]

    expected = %{
      "Comet" => {14, 10, 127, 1120, 312},
      "Dancer" => {16, 11, 162, 1056, 689}
    }

    assert expected == Day14.race(reindeers, 1000)
  end


  test "input 1" do
    IO.puts "input 1"
    File.stream!("day14.txt")
    |> Enum.map(&Day14.parse/1)
    |> Enum.map(fn (reinder = {name, _, _, _}) -> {name, Day14.fly(reinder, 2503)} end)
    |> Enum.max_by(fn ({_, dist}) -> dist end)
    |> IO.inspect
  end

  test "input 2" do
    IO.puts "input 2"
    File.stream!("day14.txt")
    |> Enum.map(&Day14.parse/1)
    |> Day14.race(2503)
    |> IO.inspect
    |> Enum.map(fn({_, {_, _, _, _, points}}) -> points end)
    |> Enum.max
    |> IO.puts
  end
end
