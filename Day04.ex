defmodule Day04 do
  def input_file() do
    "Day04Input.txt"
  end

  def read_input() do
    case File.read(input_file()) do
      {:ok, content} -> content
      {:error, reason} -> raise reason
    end
  end

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
    read_input()
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

  def part2() do
  end
end

Day04.part1()
|> IO.puts()
