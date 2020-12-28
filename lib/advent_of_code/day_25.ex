defmodule AdventOfCode.Day25 do
  def part1(input) do
    [door, card] = parse_input(input)
    ls = find_loop_size(1, door, 1)
    transform(1, card, ls)
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def find_loop_size(value, key, times) do
    case transform(value, 7, 1) do
      ^key -> times
      value -> find_loop_size(value, key, times + 1)
    end
  end

  def transform(value, _, 0), do: value

  def transform(value, subj, times) do
    transform(value |> Kernel.*(subj) |> rem(20_201_227), subj, times - 1)
  end
end
