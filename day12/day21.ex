defmodule Day21 do
  @moduledoc """

  --- Day 21: RPG Simulator 20XX ---

  Little Henry Case got a new video game for Christmas. It's an RPG, and he's
  stuck on a boss. He needs to know what equipment to buy at the shop.
  He hands you the controller.

  In this game, the player (you) and the enemy (the boss) take turns attacking.
  The player always goes first. Each attack reduces the opponent's hit points
  by at least 1. The first character at or below 0 hit points loses.

  Damage dealt by an attacker each turn is equal to the attacker's damage score
  minus the defender's armor score. An attacker always does at least 1 damage.
  So, if the attacker has a damage score of 8, and the defender has an armor
  score of 3, the defender loses 5 hit points. If the defender had an armor
  score of 300, the defender would still lose 1 hit point.

  Your damage score and armor score both start at zero. They can be increased
  by buying items in exchange for gold. You start with no items and have as
  much gold as you need. Your total damage or armor is equal to the sum of
  those stats from all of your items. You have 100 hit points.

  Here is what the item shop is selling:

  Weapons:    Cost  Damage  Armor
  Dagger        8     4       0
  Shortsword   10     5       0
  Warhammer    25     6       0
  Longsword    40     7       0
  Greataxe     74     8       0

  Armor:      Cost  Damage  Armor
  Leather      13     0       1
  Chainmail    31     0       2
  Splintmail   53     0       3
  Bandedmail   75     0       4
  Platemail   102     0       5

  Rings:      Cost  Damage  Armor
  Damage +1    25     1       0
  Damage +2    50     2       0
  Damage +3   100     3       0
  Defense +1   20     0       1
  Defense +2   40     0       2
  Defense +3   80     0       3

  You must buy exactly one weapon; no dual-wielding. Armor is optional,
  but you can't use more than one. You can buy 0-2 rings (at most one for
  each hand). You must use any items you buy. The shop only has one of
  each item, so you can't buy, for example, two rings of Damage +3.

  For example, suppose you have 8 hit points, 5 damage, and 5 armor, and
  that the boss has 12 hit points, 7 damage, and 2 armor:

  The player deals 5-2 = 3 damage; the boss goes down to 9 hit points.
  The boss deals 7-5 = 2 damage; the player goes down to 6 hit points.
  The player deals 5-2 = 3 damage; the boss goes down to 6 hit points.
  The boss deals 7-5 = 2 damage; the player goes down to 4 hit points.
  The player deals 5-2 = 3 damage; the boss goes down to 3 hit points.
  The boss deals 7-5 = 2 damage; the player goes down to 2 hit points.
  The player deals 5-2 = 3 damage; the boss goes down to 0 hit points.

  In this scenario, the player wins! (Barely.)

  You have 100 hit points. The boss's actual stats are in your puzzle input.
  What is the least amount of gold you can spend and still win the fight?

  --- Part Two ---

  Turns out the shopkeeper is working with the boss, and can persuade you
  to buy whatever items he wants. The other rules still apply, and he still
  only has one of each item.

  What is the most amount of gold you can spend and still lose the fight?

  """

  defmodule Character do
    defstruct hit: 0, damage: 0, armor: 0, items_value: 0, items: []
  end

  defmodule Item do
    defstruct name: nil, cost: 0, damage: 0, armor: 0
  end

  def weapons do
    [
      %Item{name: "Dagger",     cost: 8,  damage: 4},
      %Item{name: "Shortsword", cost: 10, damage: 5},
      %Item{name: "Warhammer",  cost: 25, damage: 6},
      %Item{name: "Longsword",  cost: 40, damage: 7},
      %Item{name: "Greataxe",   cost: 74, damage: 8},
    ] |> Enum.sort_by(fn (item) -> item.cost end)
  end

  def armors do
    [
      %Item{name: "Leather",    cost: 13,  armor: 1},
      %Item{name: "Chainmail",  cost: 31,  armor: 2},
      %Item{name: "Splintmail", cost: 53,  armor: 3},
      %Item{name: "Bandedmail", cost: 75,  armor: 4},
      %Item{name: "Platemail",  cost: 102, armor: 5}
    ] |> Enum.sort_by(fn (item) -> item.cost end)
  end

  def rings do
    [
      %Item{name: "Damage +1",  cost: 25,  damage: 1, armor: 0},
      %Item{name: "Damage +2",  cost: 50,  damage: 2, armor: 0},
      %Item{name: "Damage +3",  cost: 100, damage: 3, armor: 0},
      %Item{name: "Defense +1", cost: 20,  damage: 0, armor: 1},
      %Item{name: "Defense +2", cost: 40,  damage: 0, armor: 2},
      %Item{name: "Defense +3", cost: 80,  damage: 0, armor: 3},
    ]
  end

  def player_combinations(hit) do
    for weapon <- weapons,
        armor  <- [nil|armors],
        ring1  <- [nil|rings],
        ring2  <- [nil|rings] do

      items =
        [weapon, armor, ring1, ring2]
        |> Enum.reject(fn (item) -> is_nil(item) end)
        |> Enum.uniq

      equip(%Character{hit: hit}, items)

    end
  end

  def attack(attacker, defender) do
    impact = max(1, attacker.damage - defender.armor)
    %Character{defender | hit: defender.hit - impact}
  end

  def fight(attacker, defender, turn \\ 0) do
    attacked = attack(attacker, defender)
    if attacked.hit <= 0 do
      if rem(turn, 2) == 0 do
        {true, attacker, defender}
      else
        {false, defender, attacker}
      end
    else
      fight(attacked, attacker, turn + 1)
    end
  end

  def equip(character, items) when is_list(items) do
    Enum.reduce(items, character, &equip(&2, &1))
  end
  def equip(character, item) do
    %Character{character |
      damage: character.damage + item.damage,
      armor: character.armor + item.armor,
      items: [item|character.items],
      items_value: character.items_value + item.cost}
  end

end

ExUnit.start

defmodule Day21Test do
  use ExUnit.Case, async: true

  setup do
    {:ok,
      %{
        boss: %Day21.Character{hit: 104, damage: 8, armor: 1}
      }
    }
  end

  test "attack" do

    player = %Day21.Character{hit: 8, damage: 5, armor: 5}
    boss = %Day21.Character{hit: 12, damage: 7, armor: 2}

    boss = Day21.attack(player, boss)
    assert 9 == boss.hit
    player = Day21.attack(boss, player)
    assert 6 == player.hit
  end

  test "fight" do

    player = %Day21.Character{hit: 8, damage: 5, armor: 5}
    boss = %Day21.Character{hit: 12, damage: 7, armor: 2}

    {win, _, _} = Day21.fight(player, boss)

    assert win

  end

  test "input1", %{boss: boss} do
    IO.puts "part 1"
    Day21.player_combinations(100)
    |> Enum.filter(fn (player) -> Day21.fight(player, boss) |> elem(0) end)
    |> Enum.min_by(fn (player) -> player.items_value end)
    |> IO.inspect
  end

  test "input 2", %{boss: boss} do
    IO.puts "part 2"
    Day21.player_combinations(100)
    |> Enum.reject(fn (player) -> Day21.fight(player, boss) |> elem(0) end)
    |> Enum.map(fn (player) -> player.items_value end)
    |> Enum.max
    |> IO.inspect
  end

end
