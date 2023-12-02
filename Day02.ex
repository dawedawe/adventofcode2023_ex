defmodule Day02 do
  def inputFile() do
    "Day02Input.txt"
  end

  def maxPossible() do
    %{"red" => 12, "green" => 13, "blue" => 14}
  end

  def isValidRound(r) do
    red = Map.get(r, "red", 0)
    green = Map.get(r, "green", 0)
    blue = Map.get(r, "blue", 0)

    maxRed = Map.get(maxPossible(), "red")
    maxGreen = Map.get(maxPossible(), "green")
    maxBlue = Map.get(maxPossible(), "blue")

    red <= maxRed && green <= maxGreen && blue <= maxBlue
  end

  def readInput() do
    case File.read(inputFile()) do
      {:ok, content} -> content
      {:error, reason} -> raise reason
    end
  end

  def isValidGame(game) do
    rounds = game |> elem(1)
    Enum.all?(rounds, &isValidRound/1)
  end

  def parseRound(roundStr) do
    names = Regex.scan(~r/red|blue|green/, roundStr) |> List.flatten()

    numbers =
      Regex.scan(~r/\d+/, roundStr)
      |> List.flatten()
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))

    Enum.zip(names, numbers)
    |> Map.new(& &1)
  end

  def parseLineToGame(line) do
    lineParts = String.split(line, [":", ";"]) |> Enum.map(&String.trim(&1))
    gameId = String.split(Enum.at(lineParts, 0), " ") |> Enum.at(1) |> Integer.parse() |> elem(0)

    rounds =
      Enum.drop(lineParts, 1)
      |> Enum.map(&parseRound(&1))

    {gameId, rounds}
  end

  def parseInput(s) do
    s
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(&parseLineToGame(&1))
  end

  def parse() do
    readInput()
    |> parseInput()
  end

  def part1() do
    parse()
    |> Enum.filter(&isValidGame/1)
    |> List.foldl(0, fn x, acc -> acc + elem(x, 0) end)
  end

  def power_of_game(game) do
    roundsMaxed =
      game
      |> elem(1)
      |> Enum.reduce(fn e, acc ->
        Map.merge(e, acc, fn _key, val1, val2 -> max(val1, val2) end)
      end)

    [
      roundsMaxed |> Map.get("red", 0),
      roundsMaxed |> Map.get("green", 0),
      roundsMaxed |> Map.get("blue", 0)
    ]
    |> Enum.product()
  end

  def part2() do
    parse()
    |> Enum.map(&power_of_game/1)
    |> Enum.sum()
  end
end

Day02.part1()
|> IO.puts()

Day02.part2()
|> IO.puts()
