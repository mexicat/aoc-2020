defmodule AdventOfCode.Day12 do
  @dirs %{
    :north => :west,
    :west => :south,
    :south => :east,
    :east => :north
  }

  def part1(input) do
    {{x, y}, _} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)
      |> Enum.reduce({{0, 0}, :east}, &move_ship/2)

    manhattan_dist(x, y)
  end

  def part2(input) do
    {{x, y}, _} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_instruction/1)
      |> Enum.reduce({{0, 0}, {10, 1}}, &move_ship_and_wp/2)

    manhattan_dist(x, y)
  end

  def parse_instruction(line) do
    {dir, amt} = String.split_at(line, 1)
    {dir, String.to_integer(amt)}
  end

  def move_ship(step, {ship, dir}) do
    case step do
      {"N", n} -> {forward(ship, :north, n), dir}
      {"S", n} -> {forward(ship, :south, n), dir}
      {"W", n} -> {forward(ship, :west, n), dir}
      {"E", n} -> {forward(ship, :north, n), dir}
      {"F", n} -> {forward(ship, dir, n), dir}
      {"L", n} -> {ship, change_dir(dir, :left, div(n, 90))}
      {"R", n} -> {ship, change_dir(dir, :right, div(n, 90))}
    end
  end

  def move_ship_and_wp(step, {ship, wp}) do
    case step do
      {"N", n} -> {ship, forward(wp, :north, n)}
      {"S", n} -> {ship, forward(wp, :south, n)}
      {"W", n} -> {ship, forward(wp, :west, n)}
      {"E", n} -> {ship, forward(wp, :east, n)}
      {"F", n} -> {move_to_wp(ship, wp, n), wp}
      {"L", n} -> {ship, rotate_wp(wp, :left, div(n, 90))}
      {"R", n} -> {ship, rotate_wp(wp, :right, div(n, 90))}
    end
  end

  def change_dir(curr, _, 0), do: curr

  def change_dir(curr, dir, n) do
    change_dir(Map.get(dirs(dir), curr), dir, n - 1)
  end

  def move_to_wp(ship, _, 0), do: ship

  def move_to_wp({xs, ys}, wp = {xw, yw}, n) do
    move_to_wp({xs + xw, ys + yw}, wp, n - 1)
  end

  def rotate_wp(wp, _, 0), do: wp
  def rotate_wp({x, y}, :left, n), do: rotate_wp({-y, x}, :left, n - 1)
  def rotate_wp({x, y}, :right, n), do: rotate_wp({y, -x}, :right, n - 1)

  def forward({x, y}, :north, n), do: {x, y + n}
  def forward({x, y}, :south, n), do: {x, y - n}
  def forward({x, y}, :west, n), do: {x - n, y}
  def forward({x, y}, :east, n), do: {x + n, y}

  def dirs(:left), do: @dirs
  def dirs(:right), do: Map.new(@dirs, fn {k, v} -> {v, k} end)

  def manhattan_dist(x, y), do: abs(x) + abs(y)
end
