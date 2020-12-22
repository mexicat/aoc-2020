defmodule AdventOfCode.Day21 do
  def part1(input) do
    lines =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)

    found_allergens =
      Enum.reduce(lines, %{}, fn {ingredients, allergens}, acc ->
        Enum.reduce(allergens, acc, fn allergen, acc ->
          case Map.get(acc, allergen) do
            nil ->
              Map.put(acc, allergen, ingredients)

            ingr ->
              intersection = MapSet.intersection(ingr, ingredients)
              Map.put(acc, allergen, intersection)
          end
        end)
      end)
      |> Map.values()
      |> Enum.flat_map(&MapSet.to_list/1)
      |> Enum.uniq()

    Enum.reduce(lines, [], fn {ingredients, _}, acc ->
      Enum.reduce(ingredients, acc, fn i, acc ->
        [i | acc]
      end)
    end)
    |> Enum.frequencies()
    |> Enum.reject(fn {k, _v} -> k in found_allergens end)
    |> Enum.into(%{})
    |> Map.values()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {ingredients, allergens}, acc ->
      Enum.reduce(allergens, acc, fn allergen, acc ->
        case Map.get(acc, allergen) do
          nil ->
            Map.put(acc, allergen, ingredients)

          ingr ->
            intersection = MapSet.intersection(ingr, ingredients)
            Map.put(acc, allergen, intersection)
        end
      end)
    end)
    |> Enum.sort_by(fn {_k, v} -> MapSet.size(v) end, :asc)
    |> Stream.unfold(fn
      acc when is_list(acc) ->
        {nil, {acc, %{}}}

      {[], _} ->
        nil

      {acc, found} ->
        acc = Enum.sort_by(acc, fn {_k, v} -> MapSet.size(v) end, :asc)
        {elem, found} = find_plausible(Enum.at(acc, 0), found)

        acc =
          acc
          |> Enum.drop(1)
          |> Enum.map(fn {k, v} -> {k, MapSet.delete(v, elem)} end)

        {found, {acc, found}}
    end)
    |> Enum.at(-1)
    |> Map.values()
    |> Enum.join(",")
  end

  def parse_line(line) do
    [ingredients, allergens] = String.split(line, " (contains ")
    ingredients = ingredients |> String.split() |> MapSet.new()
    allergens = allergens |> String.replace(")", "") |> String.split(", ")
    {ingredients, allergens}
  end

  def find_plausible({allergen, plausibles}, found) do
    elem = Enum.at(plausibles, 0)
    {elem, Map.put(found, allergen, elem)}
  end
end
