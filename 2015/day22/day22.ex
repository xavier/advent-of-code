defmodule Day22 do
  @moduledoc """

  --- Day 22: Wizard Simulator 20XX ---

  Little Henry Case decides that defeating bosses with swords and stuff is boring.
  Now he's playing the game with a wizard. Of course, he gets stuck on another boss
  and needs your help again.

  In this version, combat still proceeds with the player and the boss taking
  alternating turns. The player still goes first. Now, however, you don't
  get any equipment; instead, you must choose one of your spells to cast.
  The first character at or below 0 hit points loses.

  Since you're a wizard, you don't get to wear armor, and you can't attack normally.
  However, since you do magic damage, your opponent's armor is ignored, and so the
  boss effectively has zero armor as well. As before, if armor (from a spell, in
  this case) would reduce damage below 1, it becomes 1 instead - that is, the
  boss' attacks always deal at least 1 damage.

  On each of your turns, you must select one of your spells to cast. If you
  cannot afford to cast any spell, you lose. Spells cost mana; you start
  with 500 mana, but have no maximum limit. You must have enough mana to
  cast a spell, and its cost is immediately deducted when you cast it.

  Your spells are Magic Missile, Drain, Shield, Poison, and Recharge.

  - Magic Missile costs 53 mana. It instantly does 4 damage.
  - Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
  - Shield costs 113 mana. It starts an effect that lasts for 6 turns.
    While it is active, your armor is increased by 7.
  - Poison costs 173 mana. It starts an effect that lasts for 6 turns.
    At the start of each turn while it is active, it deals the boss 3 damage.
  - Recharge costs 229 mana. It starts an effect that lasts for 5 turns.
    At the start of each turn while it is active, it gives you 101 new mana.

  Effects all work the same way. Effects apply at the start of both the player's
  turns and the boss' turns. Effects are created with a timer (the number of turns they last);
  at the start of each turn, after they apply any effect they have, their timer is decreased
  by one. If this decreases the timer to zero, the effect ends. You cannot cast a spell
  that would start an effect which is already active. However, effects can be started on
  the same turn they end.

  For example, suppose the player has 10 hit points and 250 mana, and that the boss
  has 13 hit points and 8 damage:

  -- Player turn --
  - Player has 10 hit points, 0 armor, 250 mana
  - Boss has 13 hit points
  Player casts Poison.

  -- Boss turn --
  - Player has 10 hit points, 0 armor, 77 mana
  - Boss has 13 hit points
  Poison deals 3 damage; its timer is now 5.
  Boss attacks for 8 damage.

  -- Player turn --
  - Player has 2 hit points, 0 armor, 77 mana
  - Boss has 10 hit points
  Poison deals 3 damage; its timer is now 4.
  Player casts Magic Missile, dealing 4 damage.

  -- Boss turn --
  - Player has 2 hit points, 0 armor, 24 mana
  - Boss has 3 hit points

  Poison deals 3 damage. This kills the boss, and the player wins.

  Now, suppose the same initial conditions, except that the boss
  has 14 hit points instead:

  -- Player turn --
  - Player has 10 hit points, 0 armor, 250 mana
  - Boss has 14 hit points
  Player casts Recharge.

  -- Boss turn --
  - Player has 10 hit points, 0 armor, 21 mana
  - Boss has 14 hit points
  Recharge provides 101 mana; its timer is now 4.
  Boss attacks for 8 damage!

  -- Player turn --
  - Player has 2 hit points, 0 armor, 122 mana
  - Boss has 14 hit points
  Recharge provides 101 mana; its timer is now 3.
  Player casts Shield, increasing armor by 7.

  -- Boss turn --
  - Player has 2 hit points, 7 armor, 110 mana
  - Boss has 14 hit points
  Shield's timer is now 5.
  Recharge provides 101 mana; its timer is now 2.
  Boss attacks for 8 - 7 = 1 damage!

  -- Player turn --
  - Player has 1 hit point, 7 armor, 211 mana
  - Boss has 14 hit points
  Shield's timer is now 4.
  Recharge provides 101 mana; its timer is now 1.
  Player casts Drain, dealing 2 damage, and healing 2 hit points.

  -- Boss turn --
  - Player has 3 hit points, 7 armor, 239 mana
  - Boss has 12 hit points
  Shield's timer is now 3.
  Recharge provides 101 mana; its timer is now 0.
  Recharge wears off.
  Boss attacks for 8 - 7 = 1 damage!

  -- Player turn --
  - Player has 2 hit points, 7 armor, 340 mana
  - Boss has 12 hit points
  Shield's timer is now 2.
  Player casts Poison.

  -- Boss turn --
  - Player has 2 hit points, 7 armor, 167 mana
  - Boss has 12 hit points
  Shield's timer is now 1.
  Poison deals 3 damage; its timer is now 5.
  Boss attacks for 8 - 7 = 1 damage!

  -- Player turn --
  - Player has 1 hit point, 7 armor, 167 mana
  - Boss has 9 hit points
  Shield's timer is now 0.
  Shield wears off, decreasing armor by 7.
  Poison deals 3 damage; its timer is now 4.
  Player casts Magic Missile, dealing 4 damage.

  -- Boss turn --
  - Player has 1 hit point, 0 armor, 114 mana
  - Boss has 2 hit points

  Poison deals 3 damage. This kills the boss, and the player wins.

  You start with 50 hit points and 500 mana points. The boss's actual stats
  are in your puzzle input. What is the least amount of mana you can spend
  and still win the fight? (Do not include mana recharge effects
  as "spending" negative mana.)

  """

  defmodule Character do
    defstruct hit: 0, damage: 0, armor: 0, mana: 0, mana_spent: 0, active_spells: []
  end

  defmodule Spell do
    defstruct name: nil, cost: 0, damage: 0, armor: 0, heal: 0, mana: 0, turns: 0
  end

  def spells do
    [
      %Spell{name: "Magic Missile", cost: 53,  damage: 4},
      %Spell{name: "Drain",         cost: 73,  damage: 2, heal: 2},
      %Spell{name: "Shield",        cost: 113, armor: 7,  turns: 6},
      %Spell{name: "Poison",        cost: 173, damage: 3, turns: 6},
      %Spell{name: "Recharge",      cost: 229, mana: 101, turns: 5},
    ]
  end

  def spell_by_name(name) do
    spells
    |> Enum.find(fn (spell) -> spell.name == name end)
  end

  def cast_spell(player, boss, spell) do
    player = %Character{player | mana: player.mana - spell.cost, mana_spent: player.mana_spent + spell.cost}
    if spell.turns > 0 do
      {%Character{player | active_spells: [spell|player.active_spells]}, boss}
    else
      apply_effect(player, boss, spell)
    end
  end

  def apply_effect(player, boss, spell) do
    {
      apply_effect_on_player(player, spell),
      apply_effect_on_boss(boss, spell),
    }
  end

  def apply_effect_on_player(player, %Spell{name: "Drain", heal: heal}) do
    %Character{player | hit: player.hit + heal}
  end
  def apply_effect_on_player(player, %Spell{name: "Shield", armor: armor}) do
    %Character{player | armor: armor}
  end
  def apply_effect_on_player(player, %Spell{name: "Recharge", mana: mana}) do
    %Character{player | mana: player.mana + mana}
  end
  def apply_effect_on_player(player, _), do: player

  def apply_effect_on_boss(boss, %Spell{name: "Magic Missile", damage: damage}) do
    %Character{boss | hit: boss.hit - damage}
  end
  def apply_effect_on_boss(boss, %Spell{name: "Drain", damage: damage}) do
    %Character{boss | hit: boss.hit - damage}
  end
  def apply_effect_on_boss(boss, %Spell{name: "Poison", damage: damage}) do
    %Character{boss | hit: boss.hit - damage}
  end
  def apply_effect_on_boss(boss, _), do: boss

  def apply_active_spells(player, boss) do
    player = %{player | armor: 0} # reset
    {new_active_spells, player, boss} =
      player.active_spells
      |> Enum.reduce({[], player, boss}, fn (spell, {active_spells, player, boss}) ->
        {player, boss} = apply_effect(player, boss, spell)
        if spell.turns > 1 do
          {[%Spell{spell | turns: spell.turns - 1}|active_spells], player, boss}
        else
          {active_spells, player, boss}
        end
      end)
    {%Character{player | active_spells: new_active_spells}, boss}
  end

  def player_turn(player, boss, spell) do
    {player, boss} = apply_active_spells(player, boss)
    {player, boss} = cast_spell(player, boss, spell)
    cond do
      boss.hit <= 0 ->
        {:win, player, boss}
      player.hit <= 0 ->
        {:lose, player, boss}
      true ->
        {:continue, player, boss}
    end
  end

  def boss_turn(player, boss) do
    {player, boss} = apply_active_spells(player, boss)
    player = attack(boss, player)
    cond do
      boss.hit <= 0 ->
        {:win, player, boss}
      player.hit <= 0 ->
        {:lose, player, boss}
      true ->
        {:continue, player, boss}
    end
  end

  def attack(attacker, defender) do
    impact = max(1, attacker.damage - defender.armor)
    %Character{defender | hit: defender.hit - impact}
  end

  def active_spell?(player, spell) do
    Enum.find(player.active_spells, fn (s) -> s.name == spell.name end)
  end

  def possible_spells(player, _boss) do
    spells
    |> Enum.filter(fn (spell) ->
      spell.cost <= player.mana && !active_spell?(player, spell)
    end)
  end

  def simulate_fight(player, boss) do
    win =
      possible_spells(player, boss)
      |> Enum.reduce(:cont,
        fn (spell, :cont) ->
          case simulate_turn(player, boss, spell) do
            {:win, new_player, new_boss} ->
              {:win, new_player, new_boss}
            _ ->
              :cont
          end
          (_, acc) ->
            acc
      end)
    if win == :cont do
      {:lose, player, boss}
    else
      win
    end
  end

  def simulate_turn(player, boss, spell) do
    case player_turn(player, boss, spell) do
      {:continue, player, boss} ->
        case boss_turn(player, boss) do
          {:continue, player, boss} ->
            simulate_fight(player, boss)
          outcome ->
            outcome
        end
      outcome ->
        outcome
    end
  end

end

ExUnit.start

defmodule Day22Test do
  use ExUnit.Case, async: true

  setup do
    {:ok,
      %{
        player: %Day22.Character{hit: 50, mana: 500},
        boss: %Day22.Character{hit: 58, damage: 9}
      }
    }
  end

  test "attack" do

    player = %Day22.Character{hit: 8, damage: 5, armor: 5}
    boss = %Day22.Character{hit: 12, damage: 7, armor: 2}

    boss = Day22.attack(player, boss)
    assert 9 == boss.hit
    player = Day22.attack(boss, player)
    assert 6 == player.hit
  end

  @tag skip: true
  test "example scenario 1" do

    player = %Day22.Character{hit: 10, mana: 250}
    boss   = %Day22.Character{hit: 13, damage: 8}

    # 1
    assert {:continue, player, boss} = Day22.player_turn(player, boss, Day22.spell_by_name("Poison"))

    # 2
    assert 10 == player.hit
    assert 77 == player.mana
    assert 13 == boss.hit
    assert {:continue, player, boss} = Day22.boss_turn(player, boss)

    # 3
    assert [%{name: "Poison", turns: 5}|_] = player.active_spells
    assert 2 == player.hit
    assert 77 == player.mana
    assert 10 == boss.hit
    assert {:continue, player, boss} = Day22.player_turn(player, boss, Day22.spell_by_name("Magic Missile"))

    # 4
    assert [%{name: "Poison", turns: 4}|_] = player.active_spells
    assert 2 == player.hit
    assert 24 == player.mana
    assert 3 == boss.hit
    assert {:win, _, _} = Day22.boss_turn(player, boss)

  end

  test "example scenario 2" do
    player = %Day22.Character{hit: 10, mana: 250}
    boss   = %Day22.Character{hit: 14, damage: 8}

    # 1
    assert {:continue, player, boss} = Day22.player_turn(player, boss, Day22.spell_by_name("Recharge"))

    # 2
    assert 10 == player.hit
    assert 21 == player.mana
    assert 14 == boss.hit
    assert {:continue, player, boss} = Day22.boss_turn(player, boss)

    # 3
    assert [%{name: "Recharge", turns: 4}|_] = player.active_spells
    assert 2 == player.hit
    assert 122 == player.mana
    assert 14 == boss.hit
    assert {:continue, player, boss} = Day22.player_turn(player, boss, Day22.spell_by_name("Shield"))

    # 4
    assert 110 == player.mana
    assert {:continue, player, boss} = Day22.boss_turn(player, boss)
    assert 7 == player.armor


    # 5
    assert 1 == player.hit
    assert 211 == player.mana
    assert {:continue, player, boss} = Day22.player_turn(player, boss, Day22.spell_by_name("Drain"))

    # 6
    assert 3 == player.hit
    assert 7 == player.armor
    assert 239 == player.mana
    assert {:continue, player, boss} = Day22.boss_turn(player, boss)

    # 7
    assert 2 == player.hit
    assert 7 == player.armor
    assert 340 == player.mana
    assert 12 == boss.hit
    assert {:continue, player, boss} = Day22.player_turn(player, boss, Day22.spell_by_name("Poison"))

    # 8
    assert 2 == player.hit
    assert 7 == player.armor
    assert 167 == player.mana
    assert 12 == boss.hit
    assert {:continue, player, boss} = Day22.boss_turn(player, boss)

    # 9
    assert {:continue, player, boss} = Day22.player_turn(player, boss, Day22.spell_by_name("Magic Missile"))

    # 10
    assert {:win, _, _} = Day22.boss_turn(player, boss)

  end

  @tag timeout: 5 * 60000
  test "input1", %{player: player, boss: boss} do
    IO.puts "part 1"
    Day22.simulate_fight(player, boss)
    |> IO.inspect
  end

  # test "input 2", %{boss: boss} do
  #   IO.puts "part 2"
  #   Day22.player_combinations(100)
  #   |> Enum.reject(fn (player) -> Day22.fight(player, boss) |> elem(0) end)
  #   |> Enum.map(fn (player) -> player.items_value end)
  #   |> Enum.max
  #   |> IO.inspect
  # end

end
