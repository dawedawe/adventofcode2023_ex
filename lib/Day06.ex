defmodule Day06 do
  def input_file(), do: "priv/Day06Input.txt"

  def parse_input(s) do
    s
    |> String.split(["\n", "\r\n"], trim: false)
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line)
      |> Enum.concat()
      |> Enum.map(fn s -> Integer.parse(s) |> elem(0) end)
    end)
  end

  def parse() do
    File.read!(input_file())
    |> parse_input()
    |> Enum.zip()
  end

  def calc({time, distance}) do
    for(t <- 0..time, t * (time - t) > distance, do: t)
    |> length
  end

  def part1() do
    parse()
    |> Enum.map(&calc/1)
    |> Enum.product()
  end
end

Day06.part1()
|> IO.inspect()
