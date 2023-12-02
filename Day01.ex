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

  def part1 do
    readInput()
    |> parseInput()
    |> Enum.sum()
  end

  def replace(s, acc, prefix, replacementStr, replacementNr, continuation) do
    s2 = String.replace_prefix(s, prefix, replacementStr)
    acc2 = acc <> replacementNr
    continuation.(s2, acc2)
  end

  def foldFunc(s, acc) do
    cond do
      String.starts_with?(s, "one") ->
        replace(s, acc, "one", "e", "1", &foldFunc/2)

      String.starts_with?(s, "two") ->
        replace(s, acc, "two", "o", "2", &foldFunc/2)

      String.starts_with?(s, "three") ->
        replace(s, acc, "three", "e", "3", &foldFunc/2)

      String.starts_with?(s, "four") ->
        replace(s, acc, "four", "", "4", &foldFunc/2)

      String.starts_with?(s, "five") ->
        replace(s, acc, "five", "e", "5", &foldFunc/2)

      String.starts_with?(s, "six") ->
        replace(s, acc, "six", "", "6", &foldFunc/2)

      String.starts_with?(s, "seven") ->
        replace(s, acc, "seven", "n", "7", &foldFunc/2)

      String.starts_with?(s, "eight") ->
        replace(s, acc, "eight", "t", "8", &foldFunc/2)

      String.starts_with?(s, "nine") ->
        replace(s, acc, "nine", "e", "9", &foldFunc/2)

      s == "" ->
        acc

      true ->
        {s1, s2} = String.split_at(s, 1)
        acc2 = acc <> s1
        foldFunc(s2, acc2)
    end
  end

  def parseInput2(s) do
    s
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(&foldFunc(&1, ""))
    |> Enum.map(&parseLine(&1))
  end

  def part2 do
    readInput()
    |> parseInput2()
    |> Enum.sum()
  end
end

Day01.part1()
|> IO.puts()

Day01.part2()
|> IO.puts()
