defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [min, max, letter, password] = get_line_data(line)
      check_password_1(String.to_integer(min), String.to_integer(max), letter, password)
    end)
    |> Enum.count(& &1)
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [pos_1, pos_2, letter, password] = get_line_data(line)
      check_password_2(String.to_integer(pos_1), String.to_integer(pos_2), letter, password)
    end)
    |> Enum.count(& &1)
  end

  def get_line_data(line) do
    Regex.run(~r/^(\d+)-(\d+) ([a-z]): ([a-z]+)$/, line, capture: :all_but_first)
  end

  def check_password_1(min, max, letter, password) do
    letter_count =
      password
      |> String.codepoints()
      |> Enum.count(&(&1 == letter))

    letter_count >= min && letter_count <= max
  end

  def check_password_2(pos_1, pos_2, letter, password) do
    letters = String.codepoints(password)
    # positions are 1-indexed
    pos_1_valid = Enum.at(letters, pos_1 - 1) == letter
    pos_2_valid = Enum.at(letters, pos_2 - 1) == letter

    pos_1_valid != pos_2_valid
  end
end
