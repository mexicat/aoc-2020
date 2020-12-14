defmodule AdventOfCode.Day13 do
  def part1(input) do
    [earliest_ts, timetable] = input |> String.split("\n", trim: true)
    earliest_ts = String.to_integer(earliest_ts)

    active_buses =
      timetable
      |> String.split(",")
      |> Enum.reject(&(&1 == "x"))
      |> Enum.map(&String.to_integer/1)

    {ts, bus} =
      Enum.reduce_while(
        Stream.iterate(earliest_ts, &(&1 + 1)),
        nil,
        fn ts, _ ->
          case Enum.find(active_buses, fn bus -> rem(ts, bus) == 0 end) do
            nil -> {:cont, nil}
            bus -> {:halt, {ts, bus}}
          end
        end
      )

    (ts - earliest_ts) * bus
  end

  def part2(input) do
    buses =
      input
      |> String.split("\n", trim: true)
      |> Enum.at(1)
      |> String.split(",")
      |> Enum.with_index()
      |> Enum.reject(fn {b, _} -> b == "x" end)
      |> Enum.map(fn {b, i} ->
        {String.to_integer(b), i}
      end)

    start = buses |> Enum.at(0) |> elem(0)

    Enum.reduce(buses, {start, 1}, fn {bus, i}, {ts, step} ->
      earliest_ts =
        ts
        |> Stream.unfold(&{&1, &1 + step})
        |> Enum.find(&(rem(&1 + i, bus) == 0))

      {earliest_ts, step * bus}
    end)
    |> elem(0)
  end
end
