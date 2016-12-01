defmodule Day20 do

  @moduledoc """
  --- Day 20: Infinite Elves and Infinite Houses ---

  To keep the Elves busy, Santa has them deliver some presents by hand,
  door-to-door. He sends them down a street with infinite houses numbered
  sequentially: 1, 2, 3, 4, 5, and so on.

  Each Elf is assigned a number, too, and delivers presents to houses based
  on that number:

  - The first Elf (number 1) delivers presents to every house: 1, 2, 3, 4, 5, ....
  - The second Elf (number 2) delivers presents to every second house: 2, 4, 6, 8, 10, ....
  - Elf number 3 delivers presents to every third house: 3, 6, 9, 12, 15, ....

  There are infinitely many Elves, numbered starting with 1.
  Each Elf delivers presents equal to ten times his or her number at each house.

  So, the first nine houses on the street end up like this:

  - House 1 got 10 presents.
  - House 2 got 30 presents.
  - House 3 got 40 presents.
  - House 4 got 70 presents.
  - House 5 got 60 presents.
  - House 6 got 120 presents.
  - House 7 got 80 presents.
  - House 8 got 150 presents.
  - House 9 got 130 presents.

  The first house gets 10 presents: it is visited only by Elf 1,
  which delivers 1 * 10 = 10 presents.
  The fourth house gets 70 presents, because it is visited by Elves 1, 2,
  and 4, for a total of 10 + 20 + 40 = 70 presents.

  What is the lowest house number of the house to get at least as many
  presents as the number in your puzzle input?

  --- Part Two ---

  The Elves decide they don't want to visit an infinite number of houses.
  Instead, each Elf will stop after delivering presents to 50 houses.
  To make up for it, they decide to deliver presents equal to eleven
  times their number at each house.

  With these changes, what is the new lowest house number of the house to
  get at least as many presents as the number in your puzzle input?

  """

  def count_presents(n) do
    1..n
    |> Enum.reduce(0, fn (x, acc) ->
      if rem(n, x) == 0 do
        acc + 10 * x
      else
        acc
      end
    end)
  end

  def solve1(n) do
    max = div(n, 10)
    IO.puts "oups"
    houses = for number <- 0..(max+1), into: %{}, do: {number, 0}
    Enum.reduce(1..max, houses, fn(elf, h) ->
      IO.puts elf
      presents = elf * 10
      elf..max
      |> Enum.take_every(elf)
      |> Enum.reduce(h, fn (house_num, hh) ->
        Dict.update(hh, house_num, presents, fn (current) -> current + presents end)
      end)
    end)

    houses
    |> Stream.with_index
    |> Enum.find(fn ({sum, _}) -> sum >= n end)
  end

  def count_presents_pt2(n) do
    1..n
    |> Enum.reduce({0, 0}, fn (x, {sum, cnt}) ->
      if cnt < 50 && rem(n, x) == 0 do
        {sum + 11 * x, cnt + 1}
      else
        {sum, cnt}
      end
    end)
    |> elem(0)
  end


  def solve(max) do
    n = div(max, 10)
    q = div(n, 4)
    spawn(solver(1, q, max))
    spawn(solver(q, q*2, max))
    spawn(solver(q*2, q*3, max))
    spawn(solver(q*3, q*4, max))
  end

  def solver(a, b, max) do
    fn () ->
      lowest =
        a..b
        |> Stream.drop_while(fn (n) ->
          count_presents(n) < max
        end)
        |> Enum.at(0)
      IO.puts "#{a}..#{b} -> #{lowest}"
    end
  end

   def solve_pt2(max) do
    n = div(max, 11)
    q = div(n, 4)
    spawn(solver_pt2(1, q, max))
    spawn(solver_pt2(q, q*2, max))
    spawn(solver_pt2(q*2, q*3, max))
    spawn(solver_pt2(q*3, q*4, max))
  end

  def solver_pt2(a, b, max) do
    fn () ->
      lowest =
        a..b
        |> Stream.drop_while(fn (n) ->
          #if rem(n, 1000) == 0, do: IO.puts "#{a}..#{b} -> #{n}"
          count_presents_pt2(n) < max
        end)
        |> Enum.at(0)
      IO.puts "#{a}..#{b} ---> #{lowest}"
    end
  end


end

ExUnit.start

defmodule Day20Test do
  use ExUnit.Case, async: true

  test "simple" do
    assert 10 == Day20.count_presents(1)
    assert 30 == Day20.count_presents(2)
    assert 40 == Day20.count_presents(3)
    assert 70 == Day20.count_presents(4)
    assert 60 == Day20.count_presents(5)
    assert 120 == Day20.count_presents(6)
    assert 80 == Day20.count_presents(7)
    assert 150 == Day20.count_presents(8)
    assert 130 == Day20.count_presents(9)
  end

  @tag timeout: 5*60*1000
  test "part 1" do
    IO.puts "part 1"
    Day20.solve1(34_000_000)
    |> IO.puts
  end

  # # 808720 NO

  # # 840840
  # # 840840 OK
  # # 846720 OK
  # # 850080 OK

  # @tag timeout: 5 * 60000
  # test "input 1" do
  #   # Stream.iterate(750080, fn (x) -> x + 1 end)
  #   # |> Stream.reject(fn (x) ->
  #   #   c = Day20.count_presents(x)
  #   #   IO.puts "#{x} ~ #{c}"
  #   #   c < 34_000_000
  #   # end)
  #   # |> Enum.take(1)
  # end

end

