defmodule AdventOfCode.Day14 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn
      [k, v] -> {String.to_integer(k), to_36(v)}
      x -> x
    end)
    |> decoder()
    |> Map.values()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn
      [k, v] -> {to_36(k), String.to_integer(v)}
      x -> x
    end)
    |> decoder_v2()
    |> Map.values()
    |> Enum.sum()
  end

  def decoder(instructions) do
    Enum.reduce(instructions, {%{}, nil}, fn
      {:mask, mask}, {memory, _} ->
        {memory, mask}

      {addr, val}, {memory, mask} ->
        new_val =
          Enum.zip(String.codepoints(mask), String.codepoints(val))
          |> Enum.map(fn
            {"X", n} -> n
            {v, _} -> v
          end)
          |> Enum.join()
          |> String.to_integer(2)

        {Map.put(memory, addr, new_val), mask}
    end)
    |> elem(0)
  end

  def decoder_v2(instructions) do
    Enum.reduce(instructions, {%{}, nil}, fn
      {:mask, mask}, {memory, _} ->
        {memory, mask}

      {addr, val}, {memory, mask} ->
        new_addr =
          Enum.zip(String.codepoints(mask), String.codepoints(addr))
          |> Enum.map(fn
            {"0", n} -> n
            {"1", _} -> "1"
            {"X", _} -> "X"
          end)

        comb_length = Enum.count(new_addr, &(&1 == "X"))

        replacements =
          0..round(:math.pow(2, comb_length) - 1)
          |> Enum.map(fn n ->
            n
            |> Integer.to_string(2)
            |> String.pad_leading(comb_length, "0")
            |> String.codepoints()
          end)

        addresses =
          Enum.map(replacements, fn replacement ->
            s =
              Enum.reduce(
                replacement,
                Enum.join(new_addr),
                &String.replace(&2, "X", &1, global: false)
              )

            {s, val}
          end)

        {Enum.into(addresses, memory), mask}
    end)
    |> elem(0)
  end

  def parse_line("mask = " <> rest), do: {:mask, rest}

  def parse_line("mem[" <> rest) do
    rest |> String.replace("] = ", " ") |> String.split()
  end

  def to_36(s) do
    s |> String.to_integer() |> Integer.to_string(2) |> String.pad_leading(36, "0")
  end
end
