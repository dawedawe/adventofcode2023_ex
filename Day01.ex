defmodule Day01 do
  def inputFile() do
    "Day01Input.txt"
  end

  def readInput() do
    case File.read(inputFile()) do
      {:ok, content} -> content
      {:error, reason} -> raise reason
    end
  end

  def parseLine(s) do
    s
    |> String.codepoints()
    |> Enum.filter(&(Integer.parse(&1) != :error))
    |> then(fn s -> (List.first(s) <> List.last(s)) |> Integer.parse() end)
    |> Tuple.to_list()
    |> Enum.at(0)
  end

  def parseInput(s) do
    s
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(&parseLine(&1))
  end

  def day01Part1 do
    readInput()
    |> parseInput()
    |> Enum.sum()
  end
end

Day01.day01Part1()
|> IO.puts()
