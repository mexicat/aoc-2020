defmodule AdventOfCode.Day07 do
  def part1(input) do
    graph = :digraph.new()

    input
    |> String.split("\n")
    |> Enum.map(&add_to_graph(graph, &1))

    graph
    |> :digraph.vertices()
    |> Enum.filter(&:digraph.get_path(graph, &1, "shiny gold"))
    |> Enum.count()
  end

  def part2(input) do
    bags =
      input
      |> String.replace(~r/ bag(s?)/, "")
      |> String.replace(".", "")
      |> String.split("\n", trim: true)

    start = Enum.find(bags, &String.starts_with?(&1, "shiny gold"))

    find_total_bags(bags, start) - 1
  end

  def add_to_graph(graph, line) do
    bags =
      ~r/((?:[a-z]+) (?:[a-z]+)) (?:bag)/
      |> Regex.scan(line, capture: :all_but_first)
      |> List.flatten()

    Enum.each(bags, &:digraph.add_vertex(graph, &1))
    [vert | rest] = bags |> Enum.reject(&(&1 == "no other"))
    Enum.each(rest, &:digraph.add_edge(graph, vert, &1))
  end

  def find_total_bags(bags, line) do
    [_, contained_str] = line |> String.split(" contain ")
    contained = contained_str |> String.split(", ") |> Enum.map(&Integer.parse/1)

    Enum.reduce(contained, 1, fn
      :error, acc ->
        acc

      {n, color}, acc ->
        new_line = Enum.find(bags, &String.starts_with?(&1, String.trim(color)))
        acc + n * find_total_bags(bags, new_line)
    end)
  end
end
