defmodule AdventOfCode.Day05 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&calc_seat_pos/1)
    |> Enum.map(&calc_seat_id/1)
    |> Enum.max()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&calc_seat_pos/1)
    |> Enum.map(&calc_seat_id/1)
    |> find_missing_seat()
  end

  def calc_seat_pos(seat) do
    {{r1, _r2}, {c1, _c2}} =
      Enum.reduce(seat, {{0, 128}, {0, 8}}, fn char, {row, col} ->
        case char do
          "F" -> {half(row, :lower), col}
          "B" -> {half(row, :upper), col}
          "L" -> {row, half(col, :lower)}
          "R" -> {row, half(col, :upper)}
        end
      end)

    {r1, c1}
  end

  def calc_seat_id({r, c}), do: r * 8 + c

  def find_missing_seat(seat_ids) do
    try do
      for row <- 0..127,
          col <- 0..7,
          seat_id = calc_seat_id({row, col}),
          seat_id not in seat_ids,
          (seat_id + 1) in seat_ids,
          (seat_id - 1) in seat_ids,
          do: throw({:break, seat_id})
    catch
      {:break, id} -> id
    end
  end

  def half({a, b}, :lower), do: {a, b - div(b - a, 2)}
  def half({a, b}, :upper), do: {b - div(b - a, 2), b}
end
