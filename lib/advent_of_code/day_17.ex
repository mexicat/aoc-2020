defmodule AdventOfCode.Day17 do
  def part1(input) do
    grid = parse_input(input)

    1..6
    |> Enum.reduce(grid, fn _, acc -> step(acc) end)
    |> Enum.count()
  end

  def part2(input) do
    grid = parse_input_2(input)

    1..6
    |> Enum.reduce(grid, fn _, acc -> step_2(acc) end)
    |> Enum.count()
  end

  def parse_input(input) do
    for {y, y_index} <- input |> String.split("\n") |> Enum.with_index(),
        {x, x_index} <- y |> String.codepoints() |> Enum.with_index(),
        x == "#",
        into: %{},
        do: {{x_index, y_index, 0}, true}
  end

  def step(grid) do
    {min_x, max_x} = grid |> Enum.map(fn {{x, _, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = grid |> Enum.map(fn {{_, y, _}, _} -> y end) |> Enum.min_max()
    {min_z, max_z} = grid |> Enum.map(fn {{_, _, z}, _} -> z end) |> Enum.min_max()

    for x <- (min_x - 1)..(max_x + 1),
        y <- (min_y - 1)..(max_y + 1),
        z <- (min_z - 1)..(max_z + 1) do
      nb_amt = {x, y, z} |> neighbors(grid) |> length()
      active = Map.get(grid, {x, y, z}, false)

      cond do
        active and nb_amt in 2..3 -> {{x, y, z}, true}
        active -> nil
        not active and nb_amt == 3 -> {{x, y, z}, true}
        true -> nil
      end
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{})
  end

  def neighbors({x, y, z}, grid) do
    for x1 <- (x - 1)..(x + 1),
        y1 <- (y - 1)..(y + 1),
        z1 <- (z - 1)..(z + 1),
        {x1, y1, z1} != {x, y, z} do
      {x1, y1, z1}
    end
    |> Enum.filter(fn p -> Map.get(grid, p, false) end)
  end

  # part 2 functions are copy-pasted from part 1 but with the addition of w

  def parse_input_2(input) do
    for {y, y_index} <- input |> String.split("\n") |> Enum.with_index(),
        {x, x_index} <- y |> String.codepoints() |> Enum.with_index(),
        x == "#",
        into: %{},
        do: {{x_index, y_index, 0, 0}, true}
  end

  def step_2(grid) do
    {min_x, max_x} = grid |> Enum.map(fn {{x, _, _, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = grid |> Enum.map(fn {{_, y, _, _}, _} -> y end) |> Enum.min_max()
    {min_z, max_z} = grid |> Enum.map(fn {{_, _, z, _}, _} -> z end) |> Enum.min_max()
    {min_w, max_w} = grid |> Enum.map(fn {{_, _, _, w}, _} -> w end) |> Enum.min_max()

    for x <- (min_x - 1)..(max_x + 1),
        y <- (min_y - 1)..(max_y + 1),
        z <- (min_z - 1)..(max_z + 1),
        w <- (min_w - 1)..(max_w + 1) do
      nb_amt = {x, y, z, w} |> neighbors_2(grid) |> length()
      active = Map.get(grid, {x, y, z, w}, false)

      cond do
        active and nb_amt in 2..3 -> {{x, y, z, w}, true}
        active -> nil
        not active and nb_amt == 3 -> {{x, y, z, w}, true}
        true -> nil
      end
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{})
  end

  def neighbors_2({x, y, z, w}, grid) do
    for x1 <- (x - 1)..(x + 1),
        y1 <- (y - 1)..(y + 1),
        z1 <- (z - 1)..(z + 1),
        w1 <- (w - 1)..(w + 1),
        {x1, y1, z1, w1} != {x, y, z, w} do
      {x1, y1, z1, w1}
    end
    |> Enum.filter(fn p -> Map.get(grid, p, false) end)
  end
end
