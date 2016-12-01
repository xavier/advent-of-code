defmodule Day15 do
  @moduledoc """

  --- Day 15: Science for Hungry People ---

  Today, you set out on the task of perfecting your milk-dunking cookie recipe.
  All you have to do is find the right balance of ingredients.

  Your recipe leaves room for exactly 100 teaspoons of ingredients. You make a
  list of the remaining ingredients you could use to finish the recipe (your
  puzzle input) and their properties per teaspoon:

  - capacity (how well it helps the cookie absorb milk)
  - durability (how well it keeps the cookie intact when full of milk)
  - flavor (how tasty it makes the cookie)
  - texture (how it improves the feel of the cookie)
  - calories (how many calories it adds to the cookie)

  You can only measure ingredients in whole-teaspoon amounts accurately, and
  you have to be accurate so you can reproduce your results in the future.
  The total score of a cookie can be found by adding up each of the properties
  (negative totals become 0) and then multiplying together everything except calories.

  For instance, suppose you have these two ingredients:

  - Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
  - Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3

  Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of
  cinnamon (because the amounts of each ingredient must add up to 100)
  would result in a cookie with the following properties:

  - A capacity of 44*-1 + 56*2 = 68
  - A durability of 44*-2 + 56*3 = 80
  - A flavor of 44*6 + 56*-2 = 152
  - A texture of 44*3 + 56*-1 = 76

  Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results
  in a total score of 62842880, which happens to be the best score possible given these
  ingredients. If any properties had produced a negative total, it would have instead
  become zero, causing the whole score to multiply to zero.

  Given the ingredients in your kitchen and their properties, what is the total score
  of the highest-scoring cookie you can make?

  --- Part Two ---

  Your cookie recipe becomes wildly popular! Someone asks if you can make another recipe
  that has exactly 500 calories per cookie (so they can use it as a meal replacement).
  Keep the rest of your award-winning process the same (100 teaspoons, same ingredients,
  same scoring system).

  For example, given the ingredients above, if you had instead selected 40 teaspoons of
  butterscotch and 60 teaspoons of cinnamon (which still adds to 100), the total calorie
  count would be 40*8 + 60*3 = 500. The total score would go down, though: only 57600000,
  the best you can do in such trying circumstances.

  Given the ingredients in your kitchen and their properties, what is the total score of
  the highest-scoring cookie you can make with a calorie total of 500?

  """

  defmodule Ingredient do
    defstruct name: nil, cap: 0, dur: 0, fla: 0, tex: 0, cal: 0
  end

  @regex_line ~r/^(\w+): capacity (\-?\d+), durability (\-?\d+), flavor (\-?\d+), texture (\-?\d+), calories (\d+)$/

  def parse(line) do
    case Regex.run(@regex_line, line) do
      [_, name, cap, dur, fla, tex, cal] ->
        %Ingredient{name: name, cap: to_int(cap), dur: to_int(dur), fla: to_int(fla), tex: to_int(tex), cal: to_int(cal)}
    end
  end

  defp to_int(string), do: Integer.parse(string) |> elem(0)

  def build_ingredients_map(ingredients) do
    for ingredient <- ingredients, into: %{}, do: {ingredient.name, ingredient}
  end

  def total_score(quantities, ingredients_map) do
    aggregate =
      quantities
      |> Enum.reduce(
        %Day15.Ingredient{},
        fn ({ingredient_name, qty}, acc) ->
          {:ok, ingredient} = Dict.fetch(ingredients_map, ingredient_name)
          %{acc |
              cap: acc.cap + ingredient.cap * qty,
              dur: acc.dur + ingredient.dur * qty,
              fla: acc.fla + ingredient.fla * qty,
              tex: acc.tex + ingredient.tex * qty,
              cal: acc.cal + ingredient.cal * qty
          }
        end)
    {calculate_total(aggregate.cap, aggregate.dur, aggregate.fla, aggregate.tex), aggregate.cal}
  end

  defp calculate_total(x, _, _, _) when x < 0, do: 0
  defp calculate_total(_, x, _, _) when x < 0, do: 0
  defp calculate_total(_, _, x, _) when x < 0, do: 0
  defp calculate_total(_, _, x, x) when x < 0, do: 0
  defp calculate_total(a, b, c, d), do: a * b * c * d


  def optimal_quantities(ingredients_map) do
    {combo, total_score, _} =
      ingredients_map
      |> all_total_scores
      |> Enum.max_by(&elem(&1, 1))
    {combo, total_score}
  end

  def optimal_quantities(ingredients_map, max_cal) do
    {combo, total_score, _} =
      ingredients_map
      |> all_total_scores
      |> Enum.filter(fn({_, _, cal}) -> cal == max_cal end)
      |> Enum.max_by(&elem(&1, 1))
    {combo, total_score}
  end

  defp all_total_scores(ingredients_map) do
    ingredients = Dict.keys(ingredients_map)

    Enum.count(ingredients)
    |> combinations(100)
    |> Enum.map(fn (quantities) ->
      combo = ingredients |> Enum.zip(quantities) |> Enum.into(%{})
      {score, total_cal} = total_score(combo, ingredients_map)
      {combo, score, total_cal}
    end)
  end

  defp combinations(1, total), do: [[total]]
  defp combinations(n, total) do
    (0..total)
    |> Enum.flat_map(fn(idx) ->
        combinations(n - 1, total - idx) |> Enum.map(fn (x) -> [idx|x] end)
    end)
  end

end


ExUnit.start

defmodule Day15Test do
  use ExUnit.Case, async: true

  test "parse" do
    expected = %Day15.Ingredient{name: "Sugar", cap: 3, dur: 0, fla: 0, tex: -3, cal: 2}
    assert expected == Day15.parse("Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2")
  end

  test "total_score" do

    ingredients_map =
      [
        "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8",
        "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"
      ] |> Enum.map(&Day15.parse/1) |> Day15.build_ingredients_map

    quantities = %{
      "Butterscotch" => 44,
      "Cinnamon" => 56,
    }

    assert {62842880, 8*44 + 3*56} == Day15.total_score(quantities, ingredients_map)

  end

  test "optimal_quantities" do
    ingredients_map =
      [
        "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8",
        "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"
      ] |> Enum.map(&Day15.parse/1) |> Day15.build_ingredients_map

    expected = %{
      "Butterscotch" => 44,
      "Cinnamon" => 56,
    }

    assert {expected, 62842880} == Day15.optimal_quantities(ingredients_map)

  end

  test "optimal_quantities with max_cal" do
    ingredients_map =
      [
        "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8",
        "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"
      ] |> Enum.map(&Day15.parse/1) |> Day15.build_ingredients_map

    expected = %{
      "Butterscotch" => 40,
      "Cinnamon" => 60,
    }

    assert {expected, 57600000} == Day15.optimal_quantities(ingredients_map, 500)

  end

  test "input 1" do
    IO.puts "input 1"
    File.stream!("day15.txt")
    |> Enum.map(&Day15.parse/1)
    |> Day15.build_ingredients_map
    |> Day15.optimal_quantities
    |> IO.inspect
  end

  test "input 2" do
    IO.puts "input 2"
    File.stream!("day15.txt")
    |> Enum.map(&Day15.parse/1)
    |> Day15.build_ingredients_map
    |> Day15.optimal_quantities(500)
    |> IO.inspect
  end
end
