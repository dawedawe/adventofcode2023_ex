defmodule Day03 do
  def input_file(), do: "priv/Day03Input.txt"

  defmodule Serial do
    defstruct nr: -1, len: -1, x_pos: -1, y_pos: -1

    def to_string(s) do
      "#{s.nr} #{s.len} (#{s.x_pos}, #{s.y_pos})\n"
    end

    def adjacent_positions_of_serial(serial) do
      above_and_below =
        for x <- (serial.x_pos - 1)..(serial.x_pos + serial.len) do
          [{x, serial.y_pos - 1}, {x, serial.y_pos + 1}]
        end
        |> Enum.concat()

      left_right = [{serial.x_pos - 1, serial.y_pos}, {serial.x_pos + serial.len, serial.y_pos}]
      above_and_below ++ left_right
    end

    def is_adjacent_to(serial, gear_symbol) do
      adjacent_positions = adjacent_positions_of_serial(serial)

      adjacent_positions
      |> Enum.any?(fn p -> p == gear_symbol end)
    end
  end

  def serials_from_line(line_idx, line) do
    ms = Regex.scan(~r/\d+/, line, return: :index)

    for [{idx, len}] <- ms do
      nr = String.slice(line, idx, len) |> String.to_integer()
      %Serial{nr: nr, len: len, x_pos: idx, y_pos: line_idx}
    end
  end

  def is_symbol(s), do: s != "." && Integer.parse(s) == :error

  def is_gear_symbol(s), do: s == "*"

  @spec parse_input(String.t()) :: [String.t()]
  def parse_input(s) do
    s
    |> String.split(["\n", "\r\n"], trim: true)
  end

  def serials_from_lines(lines) do
    for({line, idx} <- Enum.with_index(lines), do: serials_from_line(idx, line))
    |> Enum.concat()
  end

  def symbols_from_lines(lines, fun) do
    for {line, y} <- Enum.with_index(lines) do
      Enum.with_index(String.graphemes(line))
      |> Enum.filter(fn {c, _idx} -> fun.(c) end)
      |> Enum.map(&{elem(&1, 1), y})
    end
    |> Enum.concat()
  end

  def has_adjacent_symbol(serial, symbol_positions) do
    neighbours = Serial.adjacent_positions_of_serial(serial)

    symbol_positions
    |> Enum.filter(fn {s_x, s_y} -> Enum.any?(neighbours, &(&1 == {s_x, s_y})) end)
    |> Enum.any?()
  end

  def parse() do
    File.read!(input_file())
    |> parse_input()
  end

  def part1() do
    schema = parse()
    symbols = symbols_from_lines(schema, &is_symbol/1)

    serials_from_lines(schema)
    |> Enum.filter(fn s -> has_adjacent_symbol(s, symbols) end)
    |> Enum.map(& &1.nr)
    |> Enum.sum()
  end

  def gear_ratio(gear_symbol, serials) do
    adjacent =
      serials
      |> Enum.filter(fn serial -> Serial.is_adjacent_to(serial, gear_symbol) end)

    case adjacent do
      [s1, s2] -> s1.nr * s2.nr
      _ -> 0
    end
  end

  def part2() do
    schema = parse()
    serials = serials_from_lines(schema)

    symbols_from_lines(schema, &is_gear_symbol/1)
    |> Enum.map(fn s -> gear_ratio(s, serials) end)
    |> Enum.sum()
  end
end

Day03.part1()
|> IO.puts()

Day03.part2()
|> IO.puts()
