defmodule Tile do
  defstruct [:id, :points, rotations: 0]

  def get_borders(tile) do
    cols = Enum.zip(tile.points)

    top = Enum.at(tile.points, 0)
    right = cols |> Enum.at(-1) |> Tuple.to_list()
    bottom = Enum.at(tile.points, -1)
    left = cols |> Enum.at(0) |> Tuple.to_list()

    bs = [top, right, bottom, left]
    bs ++ Enum.map(bs, &Enum.reverse/1)
  end

  def rotate(tile, 0) do
    %{tile | rotations: rem(tile.rotations, 4)}
  end

  def rotate(tile, -1), do: rotate(tile, 3)
  def rotate(tile, -2), do: rotate(tile, 2)
  def rotate(tile, -3), do: rotate(tile, 1)

  def rotate(tile, times) do
    cols = tile.points |> Enum.zip() |> Enum.map(&Tuple.to_list/1) |> Enum.map(&Enum.reverse/1)

    rotate(%{tile | points: cols, rotations: tile.rotations + 1}, times - 1)
  end

  def flip_x(tile) do
    points = Enum.map(tile.points, &Enum.reverse/1)

    %{tile | points: points}
  end

  def flip_y(tile) do
    points =
      tile.points
      |> Enum.zip()
      |> Enum.map(fn l -> l |> Tuple.to_list() |> Enum.reverse() end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    %{tile | points: points}
  end
end

defmodule AdventOfCode.Day20 do
  def part1(input) do
    tiles = input |> parse_input()

    grid = find_next_piece(%{}, tiles, nil)

    {min_x, max_x} = grid |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = grid |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.min_max()

    b1 = grid |> Map.get({min_x, min_y}) |> IO.inspect() |> Map.get(:id)
    b2 = grid |> Map.get({min_x, max_y}) |> IO.inspect() |> Map.get(:id)
    b3 = grid |> Map.get({max_x, min_y}) |> IO.inspect() |> Map.get(:id)
    b4 = grid |> Map.get({max_x, max_y}) |> IO.inspect() |> Map.get(:id)

    b1 * b2 * b3 * b4
  end

  def part2(input) do
    tiles = input |> parse_input()

    grid = find_next_piece(%{}, tiles, nil)

    visualize_grid(grid)
  end

  def find_next_piece(grid, [], _), do: grid

  def find_next_piece(%{}, tiles, nil) do
    start_tile = Enum.min_by(tiles, fn %{id: id} -> id end)
    tiles = tiles |> List.delete(start_tile)
    grid = Map.new() |> Map.put({0, 0}, start_tile)

    find_next_piece(grid, tiles, {{0, 0}, start_tile})
  end

  def find_next_piece(grid, tiles, {{x, y}, last}) do
    [t, r, b, l, tm, rm, bm, lm] = Tile.get_borders(last)

    [
      {{0, 1}, t},
      {{1, 0}, r},
      {{0, -1}, b},
      {{-1, 0}, l},
      {{0, 1}, tm},
      {{1, 0}, rm},
      {{0, -1}, bm},
      {{-1, 0}, lm}
    ]
    |> Enum.with_index()
    |> Enum.reduce({grid, tiles}, fn
      {{{bx, by}, border}, index}, {grid, tiles} ->
        if Map.get(grid, {x + bx, y + by}) do
          {grid, tiles}
        else
          case find_matching_border(border, tiles) do
            nil ->
              {grid, tiles}

            {matching_tile, side} ->
              matching_tile =
                case {index, side} do
                  {0, 2} -> matching_tile
                  {0, 3} -> matching_tile |> Tile.rotate(-1)
                  {0, 0} -> matching_tile |> Tile.flip_y()
                  {0, 1} -> matching_tile |> Tile.rotate(1) |> Tile.flip_x()
                  {0, 6} -> matching_tile |> Tile.flip_x()
                  {0, 7} -> matching_tile |> Tile.rotate(-1) |> Tile.flip_x()
                  {0, 4} -> matching_tile |> Tile.rotate(2)
                  {0, 5} -> matching_tile |> Tile.rotate(1)
                  {1, 3} -> matching_tile
                  {1, 0} -> matching_tile |> Tile.flip_x() |> Tile.rotate(-1)
                  {1, 1} -> matching_tile |> Tile.flip_x()
                  {1, 2} -> matching_tile |> Tile.rotate(1)
                  {1, 7} -> matching_tile |> Tile.flip_y()
                  {1, 4} -> matching_tile |> Tile.rotate(-1)
                  {1, 5} -> matching_tile |> Tile.rotate(2)
                  {1, 6} -> matching_tile |> Tile.rotate(1) |> Tile.flip_y()
                  {2, 0} -> matching_tile
                  {2, 1} -> matching_tile |> Tile.rotate(-1)
                  {2, 2} -> matching_tile |> Tile.flip_y()
                  {2, 3} -> matching_tile |> Tile.rotate(1) |> Tile.flip_x()
                  {2, 4} -> matching_tile |> Tile.flip_x()
                  {2, 5} -> matching_tile |> Tile.rotate(-1) |> Tile.flip_x()
                  {2, 6} -> matching_tile |> Tile.rotate(2)
                  {2, 7} -> matching_tile |> Tile.rotate(1)
                  {3, 1} -> matching_tile
                  {3, 2} -> matching_tile |> Tile.rotate(-1) |> Tile.flip_y()
                  {3, 3} -> matching_tile |> Tile.flip_x()
                  {3, 0} -> matching_tile |> Tile.rotate(1)
                  {3, 5} -> matching_tile |> Tile.flip_y()
                  {3, 6} -> matching_tile |> Tile.rotate(-1)
                  {3, 7} -> matching_tile |> Tile.rotate(2)
                  {3, 4} -> matching_tile |> Tile.rotate(1) |> Tile.flip_y()
                end

              grid = Map.put(grid, {x + bx, y + by}, matching_tile)

              tiles_new =
                List.delete_at(
                  tiles,
                  Enum.find_index(tiles, fn t -> t.id == matching_tile.id end)
                )

              find_next_piece(grid, tiles_new, {{x + bx, y + by}, matching_tile})
          end
        end

      _, grid ->
        grid
    end)
  end

  def find_matching_border(border, tiles) do
    Enum.reduce_while(tiles, nil, fn tile, _ ->
      borders = Tile.get_borders(tile) ++ Enum.map(Tile.get_borders(tile), &Enum.reverse/1)

      if border in borders do
        side = Enum.find_index(borders, &(&1 == border))
        {:halt, {tile, side}}
      else
        {:cont, nil}
      end
    end)
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn s ->
      [id, tile] = String.split(s, ":\n", trim: true)
      id = id |> String.replace_prefix("Tile ", "") |> String.to_integer()
      points = parse_tile_points(tile)

      %Tile{id: id, points: points}
    end)
  end

  def parse_tile_points(tile) do
    tile |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)
  end

  def visualize_grid(grid) do
    {min_x, max_x} = grid |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = grid |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.min_max()

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        Map.get(grid, {x, y}) |> Map.get(:points)
      end
      |> Enum.zip()
      |> Enum.map(fn p -> p |> Tuple.to_list() |> Enum.join() end)
      |> Enum.join("\n")
    end
    |> Enum.join("\n")
    |> IO.puts()
  end
end
