defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "sum_all_numbers" do
    assert 0 == Day12.sum_all_numbers(Poison.decode!("[]"))
    assert 0 == Day12.sum_all_numbers(Poison.decode!("{}"))

    assert 6 == Day12.sum_all_numbers(Poison.decode!("[1,2,3]"))
    assert 6 == Day12.sum_all_numbers(Poison.decode!("{\"a\":2,\"b\":4}"))

    assert 3 == Day12.sum_all_numbers(Poison.decode!("[[[3]]]"))
    assert 3 == Day12.sum_all_numbers(Poison.decode!("{\"a\":{\"b\":4},\"c\":-1}"))

    assert 0 == Day12.sum_all_numbers(Poison.decode!("{\"a\":[-1,1]}"))
    assert 0 == Day12.sum_all_numbers(Poison.decode!("[-1,{\"a\":1}]"))
  end

  test "sum_all_numbers_except_red" do
    assert 0 == Day12.sum_all_numbers_except_red(Poison.decode!("[]"))
    assert 0 == Day12.sum_all_numbers_except_red(Poison.decode!("{}"))

    assert 4 == Day12.sum_all_numbers_except_red(Poison.decode!("[1,{\"c\":\"red\",\"b\":2},3]"))

    assert 0 == Day12.sum_all_numbers_except_red(Poison.decode!("{\"d\":\"red\",\"e\":[1,2,3,4],\"f\":5}"))

    assert 6 == Day12.sum_all_numbers_except_red(Poison.decode!("[1,\"red\",5]"))
  end

  test "input 1" do
    IO.puts "input 1"
    File.read!("day12.txt")
    |> Poison.decode!
    |> Day12.sum_all_numbers
    |> IO.puts
  end

  test "input 2" do
    IO.puts "input 2"
    File.read!("day12.txt")
    |> Poison.decode!
    |> Day12.sum_all_numbers_except_red
    |> IO.puts
  end
end
