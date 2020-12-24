defmodule AdventOfCode.Day24 do
  alias HexGrid.Map, as: HexMap
  alias HexGrid.Hex, as: Hex

  def part1(input) do
    tile_ops = input |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)
    grid = make_grid(tile_ops)

    grid.data
    |> Map.values()
    |> Enum.count(&(&1 == %{color: :black}))
  end

  def part2(input, days \\ 100) do
    tile_ops = input |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)
    grid = make_grid(tile_ops)

    Enum.reduce(1..days, grid, fn day, grid ->
      IO.inspect(day, label: "day")
      {min_q, max_q} = grid.data |> Enum.map(fn {%{q: q}, _} -> q end) |> Enum.min_max()
      {min_r, max_r} = grid.data |> Enum.map(fn {%{r: r}, _} -> r end) |> Enum.min_max()
      {min_s, max_s} = grid.data |> Enum.map(fn {%{s: s}, _} -> s end) |> Enum.min_max()

      for(
        q <- (min_q - 2)..(max_q + 2),
        r <- (min_r - 2)..(max_r + 2),
        s <- (min_s - 2)..(max_s + 2),
        q + r + s == 0,
        do: Hex.new!(q, r, s)
      )
      |> Enum.reduce(grid, fn h, g -> evolve(h, grid, g) end)
    end)
    |> Map.get(:data)
    |> Map.values()
    |> Enum.count(&(&1 == %{color: :black}))
  end

  def parse_line(line) do
    line |> String.codepoints() |> do_parse_line([])
  end

  def do_parse_line([], acc), do: Enum.reverse(acc)
  def do_parse_line(["s", "e" | rest], acc), do: do_parse_line(rest, [5 | acc])
  def do_parse_line(["s", "w" | rest], acc), do: do_parse_line(rest, [4 | acc])
  def do_parse_line(["n", "e" | rest], acc), do: do_parse_line(rest, [1 | acc])
  def do_parse_line(["n", "w" | rest], acc), do: do_parse_line(rest, [2 | acc])
  def do_parse_line(["e" | rest], acc), do: do_parse_line(rest, [0 | acc])
  def do_parse_line(["w" | rest], acc), do: do_parse_line(rest, [3 | acc])

  def go_to_hex(ops, start \\ Hex.new!(0, 0, 0)) do
    Enum.reduce(ops, start, fn dir, acc -> Hex.neighbour(acc, dir) end)
  end

  def make_grid(tiles) do
    {:ok, map} = HexMap.new()

    Enum.reduce(tiles, map, fn tile_ops, map ->
      hex = go_to_hex(tile_ops)

      {:ok, map} =
        case HexMap.insert(map, hex) do
          {:ok, map} -> HexMap.set(map, hex, :color, :black)
          {:error, _} -> HexMap.set(map, hex, :color, :white)
        end

      map
    end)
  end

  def evolve(hex, grid, acc) do
    neighbors = Hex.neighbours(hex)

    color =
      case HexMap.get(grid, hex, :color) do
        {:ok, col} -> col
        {:error, _} -> :white
      end

    black_nbs =
      Enum.map(neighbors, fn nb ->
        case HexMap.get(grid, nb, :color) do
          {:ok, :black} -> 1
          _ -> 0
        end
      end)
      |> Enum.sum()

    newcol =
      cond do
        color == :white and black_nbs == 2 -> :black
        color == :black and (black_nbs == 0 || black_nbs > 2) -> :white
        true -> color
      end

    {:ok, acc} =
      case HexMap.insert(acc, hex) do
        {:ok, acc} -> HexMap.set(acc, hex, :color, newcol)
        {:error, _} -> HexMap.set(acc, hex, :color, newcol)
      end

    acc
  end
end
