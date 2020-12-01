defmodule AdventOfCode.Day01 do
  def part1(input) do
    {a, b} =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> find_two_entries_that_sum_to_2020()

    a * b
  end

  def part2(input) do
    {a, b, c} =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> find_three_entries_that_sum_to_2020()

    a * b * c
  end

  def find_two_entries_that_sum_to_2020(entries) do
    Enum.reduce_while(entries, nil, fn entry, _acc ->
      n_to_find = 2020 - entry

      case Enum.find(entries, fn x -> x == n_to_find end) do
        nil -> {:cont, nil}
        x -> {:halt, {entry, x}}
      end
    end)
  end

  def find_three_entries_that_sum_to_2020(entries) do
    try do
      for a <- entries,
          b <- entries,
          c <- entries,
          a + b + c == 2020,
          # exit as soon as we find the solution
          do: throw({:break, {a, b, c}})
    catch
      {:break, result} -> result
    end
  end
end
