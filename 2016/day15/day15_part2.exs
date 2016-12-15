defmodule Day15 do

  def slot_at_time({start_position, slots}, time), do: rem(start_position + time, slots)

  def discs_aligned?(machine, time) do
    machine
    |> Enum.with_index
    |> Enum.all?(fn ({disc, index}) -> slot_at_time(disc, time + index) == 0 end)
  end

end

machine = [
  {1, 17},
  {0, 7},
  {2, 19},
  {0, 5},
  {0, 3},
  {5, 13},
  {0, 11},
]

Stream.iterate(0, fn n -> n + 1 end)
|> Stream.filter(fn (time) -> Day15.discs_aligned?(machine, time) end)
|> Enum.take(1)
|> IO.inspect
