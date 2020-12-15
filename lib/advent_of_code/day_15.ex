defmodule AdventOfCode.Day15 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> say_numbers(2020)
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> say_numbers(30_000_000)
  end

  def say_numbers(numbers, up_to, acc \\ {nil, 1, %{}})

  def say_numbers(_, up_to, {last, i, _}) when i == up_to, do: last

  def say_numbers([], up_to, {last, i, visited}) do
    case Map.get(visited, last) do
      nil -> say_numbers([], up_to, {0, i + 1, Map.put(visited, last, i)})
      x -> say_numbers([], up_to, {i - x, i + 1, Map.put(visited, last, i)})
    end
  end

  # last of the original numbers, don't increase i
  def say_numbers([n], up_to, {_, i, visited}) do
    say_numbers([], up_to, {n, i, Map.put(visited, n, i)})
  end

  def say_numbers([n | rest], up_to, {_, i, visited}) do
    say_numbers(rest, up_to, {n, i + 1, Map.put(visited, n, i)})
  end
end
