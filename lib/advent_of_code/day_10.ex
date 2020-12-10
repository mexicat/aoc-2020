defmodule AdventOfCode.Day10 do
  def part1(input) do
    {j1, j3} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
      |> count_joltage()

    j1 * j3
  end

  def part2(input) do
    Agent.start_link(&Map.new/0, name: __MODULE__)

    res = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> find_combinations(0)

    Agent.stop(__MODULE__)

    res
  end

  def count_joltage(adapters) do
    {_, j1, j3} =
      Enum.reduce(adapters, {0, 0, 1}, fn adapter, {last, j1, j3} ->
        case adapter - last do
          1 -> {adapter, j1 + 1, j3}
          3 -> {adapter, j1, j3 + 1}
          _ -> {adapter, j1, j3}
        end
      end)

    {j1, j3}
  end

  def find_combinations(adapters, adapter) do
    case Agent.get(__MODULE__, &Map.get(&1, adapter)) do
      nil ->
        val = reachable_adapters(adapters, adapter)
        Agent.update(__MODULE__, &Map.put(&1, adapter, val))
        val

      x -> x
    end
  end

  def reachable_adapters(adapters, adapter) do
    adapters
    |> Enum.filter(fn a -> a in (adapter + 1)..(adapter + 3) end)
    |> case do
      [] -> 1
      [a] -> find_combinations(adapters, a)
      a -> a |> Enum.map(&find_combinations(adapters, &1)) |> Enum.sum()
    end
  end
end
