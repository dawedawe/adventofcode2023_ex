defmodule Day07 do
  def input_file(), do: "priv/Day07Input.txt"

  def parse_input(s) do
    s
    |> String.split(["\n", "\r\n"], trim: false)
  end

  def parse() do
    File.read!(input_file())
    |> parse_input()
    |> Enum.map(&String.split(&1, [" "]))
    |> Enum.map(fn [card, bid] ->
      {card, Integer.parse(bid) |> elem(0)}
    end)
  end

  def is_five_of_a_kind?([x, x, x, x, x]), do: true
  def is_five_of_a_kind?([_, _, _, _, _]), do: false

  def is_four_of_a_kind?(cards) do
    cards
    |> Enum.group_by(& &1)
    |> Map.values()
    |> Enum.any?(&(length(&1) == 4))
  end

  def is_full_house?(cards) do
    groups =
      cards
      |> Enum.group_by(& &1)
      |> Map.values()

    length(groups) == 2 && Enum.any?(groups, &(length(&1) == 3))
  end

  def is_three_of_a_kind?(cards) do
    groups =
      cards
      |> Enum.group_by(& &1)
      |> Map.values()

    length(groups) == 3 && Enum.any?(groups, &(length(&1) == 3))
  end

  def is_two_pair?(cards) do
    groups =
      cards
      |> Enum.group_by(& &1)
      |> Map.values()

    length(groups) == 3 && Enum.count(groups, &(length(&1) == 2)) == 2
  end

  def is_high_card?(cards) do
    cards
    |> Enum.group_by(& &1)
    |> Map.keys()
    |> then(&(length(&1) == 5))
  end

  def is_one_pair?(cards) do
    groups =
      cards
      |> Enum.group_by(& &1)
      |> Map.values()

    length(groups) == 4
  end

  def type_of_card(card) do
    cond do
      is_five_of_a_kind?(card) -> :five_of_a_kind
      is_four_of_a_kind?(card) -> :four_of_a_kind
      is_full_house?(card) -> :full_house
      is_three_of_a_kind?(card) -> :three_of_a_kind
      is_two_pair?(card) -> :two_pair
      is_one_pair?(card) -> :one_pair
      is_high_card?(card) -> :is_high_card
    end
  end

  def type_strength_map() do
    %{
      :five_of_a_kind => 6,
      :four_of_a_kind => 5,
      :full_house => 4,
      :three_of_a_kind => 3,
      :two_pair => 2,
      :one_pair => 1,
      :is_high_card => 0
    }
  end

  def type_strength(c) do
    t = type_of_card(c)
    type_strength_map()[t]
  end

  def is_five_of_a_kind_possible?(cards) do
    is_five_of_a_kind?(cards) ||
      cards
      |> Enum.filter(&(&1 != "J"))
      |> Enum.group_by(& &1)
      |> Map.values()
      |> then(&(length(&1) == 1))
  end

  def is_four_of_a_kind_possible?(cards) do
    is_four_of_a_kind?(cards) ||
      (
        j_count = cards |> Enum.count(&(&1 == "J"))

        cards
        |> Enum.filter(&(&1 != "J"))
        |> Enum.group_by(& &1)
        |> Map.values()
        |> Enum.max_by(&length/1)
        |> then(&(length(&1) + j_count == 4))
      )
  end

  def is_full_house_possible?(cards) do
    is_full_house?(cards) ||
      (
        j_count = cards |> Enum.count(&(&1 == "J"))

        groups =
          cards
          |> Enum.filter(&(&1 != "J"))
          |> Enum.group_by(& &1)
          |> Map.values()

        cond do
          j_count == 1 -> length(groups) == 2
          j_count == 2 -> length(groups) == 2
          j_count == 3 -> length(groups) >= 1
          true -> raise("bad state")
        end
      )
  end

  def is_three_of_a_kind_possible?(cards) do
    is_three_of_a_kind?(cards) ||
      (
        j_count = cards |> Enum.count(&(&1 == "J"))

        groups =
          cards
          |> Enum.filter(&(&1 != "J"))
          |> Enum.group_by(& &1)
          |> Map.values()

        cond do
          j_count == 1 -> length(groups) == 2 || length(groups) == 3
          j_count == 2 -> length(groups) <= 3
          j_count == 3 -> length(groups) <= 2
          true -> raise("bad state")
        end
      )
  end

  def is_two_pair_possible?(cards) do
    is_two_pair?(cards) ||
      (
        j_count = cards |> Enum.count(&(&1 == "J"))

        groups =
          cards
          |> Enum.filter(&(&1 != "J"))
          |> Enum.group_by(& &1)
          |> Map.values()

        cond do
          j_count == 1 -> length(groups) == 2
          j_count == 2 -> true
          true -> raise("bad state")
        end
      )
  end

  def is_one_pair_possible?(cards) do
    is_one_pair?(cards) ||
      (
        j_count = cards |> Enum.count(&(&1 == "J"))

        groups =
          cards
          |> Enum.filter(&(&1 != "J"))
          |> Enum.group_by(& &1)
          |> Map.values()

        cond do
          j_count == 1 -> length(groups) == 4 || length(groups) == 3
          j_count == 2 -> length(groups) == 3 || length(groups) == 2
          true -> raise("bad state")
        end
      )
  end

  def try_joker(c, t) do
    cond do
      is_five_of_a_kind_possible?(c) ->
        :five_of_a_kind

      is_four_of_a_kind_possible?(c) ->
        :four_of_a_kind

      is_full_house_possible?(c) ->
        :full_house

      is_three_of_a_kind_possible?(c) ->
        :three_of_a_kind

      is_two_pair_possible?(c) ->
        :two_pair

        is_one_pair_possible?(c) ->
        :one_pair

      true ->
        t
    end
  end

  def type_strength_part2(c) do
    t = type_of_card(c)

    t2 =
      if Enum.member?(c, "J") do
        try_joker(c, t)
      else
        t
      end

    type_strength_map()[t2]
  end

  def card_strength(c) do
    m =
      %{
        "A" => 12,
        "K" => 11,
        "Q" => 10,
        "J" => 9,
        "T" => 8,
        "9" => 7,
        "8" => 6,
        "7" => 5,
        "6" => 4,
        "5" => 3,
        "4" => 2,
        "3" => 1,
        "2" => 0
      }

    m[c]
  end

  def card_strength_part2(c) do
    m =
      %{
        "A" => 12,
        "K" => 11,
        "Q" => 10,
        "T" => 9,
        "9" => 8,
        "8" => 7,
        "7" => 6,
        "6" => 5,
        "5" => 4,
        "4" => 3,
        "3" => 2,
        "2" => 1,
        "J" => 0
      }

    m[c]
  end

  def compare_relative(a, b, f) do
    {x, y} =
      Enum.zip(a, b)
      |> Enum.find(fn {x, y} -> x != y end)

    if f.(x) < f.(y) do
      true
    else
      false
    end
  end

  def compare({card_a, _bid_a}, {card_b, _bid_b}) do
    a = String.graphemes(card_a)
    b = String.graphemes(card_b)
    a_type_strength = type_strength(a)
    b_type_strength = type_strength(b)

    cond do
      a_type_strength < b_type_strength -> true
      a_type_strength > b_type_strength -> false
      a_type_strength == b_type_strength -> compare_relative(a, b, &card_strength/1)
    end
  end

  def part1() do
    parse()
    |> Enum.sort(&compare/2)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  def compare_part2({card_a, _bid_a}, {card_b, _bid_b}) do
    a = String.graphemes(card_a)
    b = String.graphemes(card_b)
    a_type_strength = type_strength_part2(a)
    b_type_strength = type_strength_part2(b)

    cond do
      a_type_strength < b_type_strength -> true
      a_type_strength > b_type_strength -> false
      a_type_strength == b_type_strength -> compare_relative(a, b, &card_strength_part2/1)
    end
  end

  def part2() do
    parse()
    |> Enum.sort(&compare_part2/2)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end
end

Day07.part1()
|> IO.inspect()

Day07.part2()
|> IO.inspect()
