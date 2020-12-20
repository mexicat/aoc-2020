defmodule AdventOfCode.Day19 do
  def part1(input) do
    {rules, messages, first} = parse_input(input)

    Enum.count(messages, &valid?(&1, first, rules))
  end

  def part2(input) do
    input =
      input
      |> String.replace("8: 42", "8: 42 | 42 8")
      |> String.replace("11: 42 31", "11: 42 31 | 42 11 31")

    {rules, messages, first} = parse_input(input)

    Enum.count(messages, &valid?(&1, first, rules))
  end

  def parse_input(input) do
    [rules, messages] = String.split(input, "\n\n")

    rules = rules |> String.split("\n") |> Enum.reduce(%{}, &parse_rule/2)
    messages = messages |> String.split("\n") |> Enum.map(&String.codepoints/1)
    first = Map.get(rules, "0")

    {rules, messages, first}
  end

  def parse_rule(line, rules) do
    [n, val] = String.split(line, ": ")

    val =
      if String.contains?(val, "\"") do
        String.trim(val, "\"")
      else
        val |> String.split(" | ") |> Enum.map(&String.split/1)
      end

    Map.put(rules, n, val)
  end

  def valid?([], [], _), do: true
  def valid?([], _, _), do: false
  def valid?(_, [], _), do: false

  def valid?(chars, [[i1, i2] | is], rules) when is_list(i1) and is_list(i2) do
    Enum.find([i1, i2], false, &valid?(chars, [&1 | is], rules))
  end

  def valid?(chars, [i | is], rules) when is_list(i) do
    valid?(chars, i ++ is, rules)
  end

  def valid?([char | chars], [char | is], rules) when char in ["a", "b"] do
    valid?(chars, is, rules)
  end

  def valid?([char | _], [i | _], _) when i in ["a", "b"] and char != i, do: false

  def valid?(chars, [i | is], rules) do
    rule = Map.get(rules, i)
    valid?(chars, [rule | is], rules)
  end
end
