defmodule Day04 do
  def input_file(), do: "priv/Day04Input.txt"

  def parse_line(line) do
    [card_part, winning_part, have_part] = String.split(line, [":", "|"])

    [[cardid]] =
      Regex.scan(~r/\d+/, card_part)
      |> Enum.map(fn lst -> Enum.map(lst, fn x -> Integer.parse(x) |> elem(0) end) end)

    winning_numbers =
      Regex.scan(~r/\d+/, winning_part)
      |> Enum.map(fn lst -> Enum.map(lst, fn x -> Integer.parse(x) end) end)
      |> Enum.concat()
      |> Enum.map(&elem(&1, 0))

    have_numbers =
      Regex.scan(~r/\d+/, have_part)
      |> Enum.map(fn lst -> Enum.map(lst, fn x -> Integer.parse(x) end) end)
      |> Enum.concat()
      |> Enum.map(&elem(&1, 0))

    {cardid, winning_numbers, have_numbers}
  end

  @spec parse_input(String.t()) :: [String.t()]
  def parse_input(s) do
    s
    |> String.split(["\n", "\r\n"], trim: true)
  end

  def parse() do
    File.read!(input_file())
    |> parse_input()
    |> Enum.map(&parse_line/1)
  end

  def calc_line({_cardid, winning_numbers, have_numbers}) do
    win_set = MapSet.new(winning_numbers)
    have_set = MapSet.new(have_numbers)
    inter_size = MapSet.intersection(win_set, have_set) |> MapSet.size()

    if inter_size >= 1 do
      2 ** (inter_size - 1)
    else
      0
    end
  end

  def part1() do
    parse()
    |> Enum.map(&calc_line/1)
    |> Enum.sum()
  end

  def get_card_ids_to_copy(max_id, {cardid, winning_numbers, have_numbers}) do
    win_set = MapSet.new(winning_numbers)
    have_set = MapSet.new(have_numbers)
    inter_size = MapSet.intersection(win_set, have_set) |> MapSet.size()

    if inter_size < 1 || cardid == max_id do
      []
    else
      Range.new(cardid + 1, min(max_id, cardid + inter_size))
      |> Range.to_list()
    end
  end

  def process_card(cards, copies_map, id) do
    instances = Map.get(copies_map, id)
    max_id = copies_map |> Map.keys() |> Enum.max()

    if id < max_id do
      card_to_process = cards |> Enum.at(id - 1)
      card_ids_to_copy = get_card_ids_to_copy(max_id, card_to_process)

      next_copies_map =
        List.foldl(
          card_ids_to_copy,
          copies_map,
          fn idToCopy, acc ->
            Map.update!(acc, idToCopy, fn value -> value + instances end)
          end
        )

      process_card(cards, next_copies_map, id + 1)
    else
      copies_map
    end
  end

  def part2() do
    cards = parse()
    copies_map = Map.new(cards, fn x -> {elem(x, 0), 1} end)

    process_card(cards, copies_map, elem(hd(cards), 0))
    |> Map.values()
    |> Enum.sum()
  end
end

Day04.part1()
|> IO.puts()

Day04.part2()
|> IO.inspect()
