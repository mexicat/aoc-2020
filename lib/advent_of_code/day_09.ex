defmodule AdventOfCode.Day09 do
  def part1(input, preamble \\ 25) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> check_numbers(preamble)
  end

  def part2(input, preamble \\ 25) do
    to_find = input |> part1(preamble)

    {x, y} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> find_chunk(to_find)

    x + y
  end

  def check_numbers(numbers, preamble) do
    Enum.reduce_while(numbers, [], fn
      n, checked when length(checked) <= preamble ->
        {:cont, [n | checked]}

      n, checked ->
        case find_number(n, Enum.take(checked, preamble)) do
          {_, _} -> {:cont, [n | checked]}
          [] -> {:halt, n}
        end
    end)
  end

  def find_number(number, preamble) do
    try do
      for x <- preamble, y <- preamble, x != y, x + y == number, do: throw({x, y})
    catch
      {x, y} -> {x, y}
    end
  end

  def find_chunk(numbers, to_find, at \\ 0, len \\ 1) do
    chunk = Enum.slice(numbers, at, len)
    sum = Enum.sum(chunk)

    cond do
      sum > to_find -> find_chunk(numbers, to_find, at + 1, 1)
      sum < to_find -> find_chunk(numbers, to_find, at, len + 1)
      sum == to_find -> {Enum.min(chunk), Enum.max(chunk)}
    end
  end
end
