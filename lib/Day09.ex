defmodule Day09 do
  def input_file(), do: "priv/Day09Input.txt"

  def parse_input(s) do
    s
    |> String.split(["\n", "\r\n"], trim: false)
  end

  def parse() do
    File.read!(input_file())
    |> parse_input()
    |> Enum.map(fn line ->
      line |> String.split(" ") |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    end)
  end

  def calc_diffs(numbers, acc \\ [])

  def calc_diffs(numbers, acc) when length(numbers) <= 1 do
    acc
  end

  def calc_diffs([h, n | t], acc) do
    next_acc = Enum.concat(acc, [n - h])
    calc_diffs([n | t], next_acc)
  end

  def calc_history(history) do
    last_diffs = List.last(history)
    all_zero = Enum.count(last_diffs, & &1 != 0) == 0

    if all_zero do
      history
    else
      diffs = calc_diffs(last_diffs)
      next_history = List.insert_at(history, length(history), diffs)
      calc_history(next_history)
    end
  end

  def calc_extrapolated(numbers) do
    history = calc_history(numbers) |> Enum.reverse()

    List.foldl(history, 0, fn elem, acc ->
      List.last(elem) + acc
    end)
  end

  def part1() do
    parse()
    |> Enum.map(fn line -> calc_extrapolated([line]) end)
    |> Enum.sum()
  end
end

Day09.part1()
|> IO.inspect()
