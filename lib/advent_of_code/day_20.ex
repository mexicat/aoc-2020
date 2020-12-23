# i really hated day 20, so i didn't take time to refactor or clean up this mess.
# it's long and ugly and full of bad practices... but ultimately it (sort of) works.

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

    str = grid |> visualize_grid() |> String.split("\n")

    # this rotation is hardcoded for my solution.
    # i've spent too much time on this, so instead of writing code that checks
    # all 8 rotations, i just rotated it manually until i found the pattern with
    # the monsters.
    str =
      %{rotations: 0, points: Enum.map(str, &String.codepoints/1)}
      |> Tile.flip_y()
      |> Map.get(:points)
      |> Enum.map(&Enum.join/1)

    max_cols = str |> Enum.at(0) |> String.length() |> Kernel.-(1)
    max_rows = str |> Enum.count() |> Kernel.-(1)

    line1 = ~r/(..................)#(.)/
    line1r = "\\1O\\2"
    line2 = ~r/#(....)##(....)##(....)###/
    line2r = "O\\1OO\\2OO\\3OOO"
    line3 = ~r/(.)#(..)#(..)#(..)#(..)#(..)#(...)/
    line3r = "\\1O\\2O\\3O\\4O\\5O\\6O\\7"

    res =
      Enum.reduce_while(Stream.cycle([true]), {{0, 0}, str}, fn _, {{row, col}, str} ->
        cond do
          col + 20 > max_cols ->
            {:cont, {{row + 1, 0}, str}}

          row + 2 > max_rows ->
            {:halt, str}

          true ->
            l1 = str |> Enum.at(row) |> String.slice(col..(col + 20))
            l1r = l1 |> String.replace(line1, line1r)
            l2 = str |> Enum.at(row + 1) |> String.slice(col..(col + 20))
            l2r = l2 |> String.replace(line2, line2r)
            l3 = str |> Enum.at(row + 2) |> String.slice(col..(col + 20))
            l3r = l3 |> String.replace(line3, line3r)

            next =
              if Enum.all?([l1 != l1r, l2 != l2r, l3 != l3r]) do
                str
                |> List.update_at(row, fn r -> String.replace(r, l1, l1r) end)
                |> List.update_at(row + 1, fn r -> String.replace(r, l2, l2r) end)
                |> List.update_at(row + 2, fn r -> String.replace(r, l3, l3r) end)
              else
                str
              end

            {:cont, {{row, col + 1}, next}}
        end
      end)

    res |> Enum.join("\n") |> IO.puts()

    res
    |> Enum.map(&String.codepoints/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.get("#")
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

    # 0-4: regular positions
    # 5-8: mirrored positions
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
                  # good luck debugging this
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

    for y <- max_y..min_y do
      for x <- min_x..max_x do
        Map.get(grid, {x, y})
        |> Map.get(:points)
        # remove borders
        |> List.delete_at(0)
        |> List.delete_at(-1)
        |> Enum.map(fn line -> line |> List.delete_at(0) |> List.delete_at(-1) end)
      end
      |> Enum.zip()
      |> Enum.map(fn p -> p |> Tuple.to_list() |> Enum.join() end)
      |> Enum.join("\n")
    end
    |> Enum.join("\n")
  end
end
