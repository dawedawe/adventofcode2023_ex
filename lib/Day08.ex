defmodule Day08 do
  def input_file(), do: "priv/Day08Input.txt"

  @spec parse_line(binary()) :: %{binary() => {binary(), binary()}}
  def parse_line(s) do
    node = String.slice(s, 0, 3)
    left = String.slice(s, 7, 3)
    right = String.slice(s, 12, 3)

    %{node => {left, right}}
  end

  def parse_input(s) do
    s
    |> String.split(["\n", "\r\n"], trim: false)
  end

  def parse() do
    File.read!(input_file())
    |> parse_input()
    |> then(fn [h, _ | t] ->
      {h |> String.codepoints(), t |> Enum.map(&parse_line/1) |> Enum.reduce(&Map.merge/2)}
    end)
  end

  def count_steps(instructions, map, inst_ptr, current_node, acc, end_predicate)
      when inst_ptr == length(instructions) do
    count_steps(instructions, map, 0, current_node, acc, end_predicate)
  end

  def count_steps(instructions, map, inst_ptr, current_node, acc, end_predicate) do
    h = instructions |> Enum.at(inst_ptr)
    next_acc = acc + 1

    next_node =
      cond do
        h == "L" -> map[current_node] |> elem(0)
        h == "R" -> map[current_node] |> elem(1)
        true -> raise("unsupported instructions #{h}")
      end

    if end_predicate.(next_node) do
      next_acc
    else
      count_steps(instructions, map, inst_ptr + 1, next_node, next_acc, end_predicate)
    end
  end

  def part1() do
    {instructions, map} = parse()
    count_steps(instructions, map, 0, "AAA", 0, fn n -> n == "ZZZ" end)
  end

  def count_steps2(current, max, steps) do
    all_good = Enum.all?(steps, fn x -> rem(current, x) == 0 end)

    if all_good do
      current
    else
      next_current = current + max
      count_steps2(next_current, max, steps)
    end
  end

  def part2() do
    {instructions, map} = parse()

    current_nodes =
      map
      |> Map.keys()
      |> Enum.filter(fn s -> String.ends_with?(s, "A") end)

    steps =
      current_nodes
      |> Enum.map(fn n ->
        count_steps(instructions, map, 0, n, 0, fn n -> String.ends_with?(n, "Z") end)
      end)

    max = Enum.max(steps)
    steps_wo_max = Enum.filter(steps, &(&1 != max))
    count_steps2(max, max, steps_wo_max)
  end
end

Day08.part1()
|> IO.inspect()

Day08.part2()
|> IO.inspect()
