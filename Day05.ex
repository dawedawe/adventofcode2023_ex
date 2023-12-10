defmodule Day05 do
  def input_file() do
    "Day05Input.txt"
  end

  def read_input() do
    case File.read(input_file()) do
      {:ok, content} -> content
      {:error, reason} -> raise reason
    end
  end

  def parse_map_line(line) do
    Regex.scan(~r/\d+/, line)
    |> Enum.concat()
    |> Enum.map(fn s -> elem(Integer.parse(s), 0) end)
    |> then(fn [dest, source, len] -> %{:dest => dest, :source => source, :len => len} end)
  end

  def parse_maps(acc, lines) when length(lines) > 0 do
    map =
      lines
      |> Enum.drop(1)
      |> Enum.take_while(&(&1 != ""))
      |> Enum.map(&parse_map_line/1)
      |> Enum.reverse()

    acc_new = acc ++ [map]
    rest = lines |> Enum.drop(2 + length(map))
    parse_maps(acc_new, rest)
  end

  def parse_maps(acc, _lines) do
    acc
  end

  def target_for(seed, mp) do
    entry =
      Enum.find(mp, fn m -> seed >= m.source && seed < m.source + m.len end)

    case entry do
      nil ->
        seed

      e ->
        offset = seed - e.source
        e.dest + offset
    end
  end

  def location_for_seed(seed, [m1, m2, m3, m4, m5, m6, m7]) do
    seed
    |> target_for(m1)
    |> target_for(m2)
    |> target_for(m3)
    |> target_for(m4)
    |> target_for(m5)
    |> target_for(m6)
    |> target_for(m7)
  end

  @spec parse_input(String.t()) :: [String.t()]
  def parse_input(s) do
    lines = s |> String.split(["\n", "\r\n"], trim: false)

    seeds =
      Regex.scan(~r/\d+/, hd(lines))
      |> Enum.concat()
      |> Enum.map(fn s -> elem(Integer.parse(s), 0) end)

    map_lines = lines |> Enum.drop(2)
    maps = parse_maps([], map_lines)
    {seeds, maps}
  end

  def parse() do
    read_input()
    |> parse_input()
  end

  def part1() do
    {seeds, maps} = parse()

    seeds
    |> Enum.map(fn seed -> location_for_seed(seed, maps) end)
    |> Enum.min()
  end
end

Day05.part1()
|> IO.puts()
