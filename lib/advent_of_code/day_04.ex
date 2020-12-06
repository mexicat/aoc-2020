defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&valid_passport_1?/1)
    |> Enum.count(& &1)
  end

  def part2(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&(valid_passport_1?(&1) and valid_passport_2?(&1)))
    |> Enum.count(& &1)
  end

  def valid_passport_1?(passport) do
    ~w/byr iyr eyr hgt hcl ecl pid/
    |> Enum.map(&String.contains?(passport, &1 <> ":"))
    |> Enum.all?(& &1)
  end

  def valid_passport_2?(passport) do
    passport
    |> String.split()
    |> Enum.map(fn fragment ->
      [field, content] = String.split(fragment, ":")
      valid_field?(field, content)
    end)
    |> Enum.all?(& &1)
  end

  def valid_field?("byr", date), do: valid_date_range?(date, 1920..2002)
  def valid_field?("iyr", date), do: valid_date_range?(date, 2010..2020)
  def valid_field?("eyr", date), do: valid_date_range?(date, 2020..2030)

  def valid_field?("hgt", height) do
    case Integer.parse(height) do
      {h, "cm"} -> h in 150..193
      {h, "in"} -> h in 59..76
      _ -> false
    end
  end

  def valid_field?("hcl", "#" <> color) do
    Regex.match?(~r/^([0-9a-f]){6}$/, color)
  end

  def valid_field?("ecl", color) when color in ~w/amb blu brn gry grn hzl oth/, do: true

  def valid_field?("pid", id) do
    Regex.match?(~r/^([0-9]){9}$/, id)
  end

  def valid_field?("cid", _), do: true

  def valid_field?(_, _), do: false

  def valid_date_range?(date, range) do
    date |> String.to_integer() |> Kernel.in(range)
  end
end
