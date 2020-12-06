defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.replace(&1, ~r/\s/, ""))
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(&(&1 + &2))
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&find_common_answers/1)
    |> Enum.reduce(&(&1 + &2))
  end

  def find_common_answers(group) do
    frequencies = Enum.frequencies(group)
    lines = Map.get(frequencies, "\n", 0) + 1

    frequencies |> Enum.filter(fn {_k, v} -> v == lines end) |> Enum.count()
  end
end
