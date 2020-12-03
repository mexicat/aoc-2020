defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> walk_map(3, 1)
    |> Enum.count(& &1)
  end

  def part2(input) do
    rows =
      input
      |> String.trim()
      |> String.split("\n")

    slope_1 = rows |> walk_map(1, 1) |> Enum.count(& &1)
    slope_2 = rows |> walk_map(3, 1) |> Enum.count(& &1)
    slope_3 = rows |> walk_map(5, 1) |> Enum.count(& &1)
    slope_4 = rows |> walk_map(7, 1) |> Enum.count(& &1)
    slope_5 = rows |> walk_map(1, 2) |> Enum.count(& &1)

    slope_1 * slope_2 * slope_3 * slope_4 * slope_5
  end

  def walk_map(rows, right, down) do
    Stream.unfold({0, 0}, fn {x, y} ->
      case rows |> Enum.at(y) |> get_x_position(x) do
        "." -> {false, {x + right, y + down}}
        "#" -> {true, {x + right, y + down}}
        nil -> nil
      end
    end)
  end

  defp get_x_position(nil, _), do: nil

  defp get_x_position(row, position) do
    if position >= String.length(row) do
      get_x_position(row, rem(position, String.length(row)))
    else
      String.at(row, position)
    end
  end
end
