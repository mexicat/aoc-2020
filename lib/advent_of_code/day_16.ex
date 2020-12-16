defmodule AdventOfCode.Day16 do
  def part1(input) do
    {fields, _my_ticket, tickets} = parse_input(input)

    Enum.reduce(tickets, 0, fn ticket, total ->
      ticket
      |> Enum.map(fn ticket_field ->
        case Enum.find(fields, fn {_, r1, r2} -> ticket_field in r1 or ticket_field in r2 end) do
          nil -> ticket_field
          _range -> 0
        end
      end)
      |> Enum.sum()
      |> Kernel.+(total)
    end)
  end

  def part2(input) do
    {fields, my_ticket, tickets} = parse_input(input)

    # this mega-pipe should be split in different functions for better testability...
    # find the valid tickets
    Enum.reduce([my_ticket | tickets], [], fn ticket, valid_tickets ->
      ticket
      |> Enum.map(fn ticket_field ->
        case Enum.find(fields, fn {_, r1, r2} -> ticket_field in r1 or ticket_field in r2 end) do
          nil -> false
          _range -> true
        end
      end)
      |> Enum.all?(& &1)
      |> if(do: [ticket | valid_tickets], else: valid_tickets)
    end)
    # zip all the valid tickets into columns
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.with_index()
    |> Enum.map(fn {col, col_i} ->
      plaus =
        Enum.reduce(fields, [], fn {label, r1, r2}, plausible ->
          if Enum.all?(col, fn f -> f in r1 or f in r2 end),
            do: [label | plausible],
            else: plausible
        end)

      {plaus, col_i}
    end)
    # find the correct field for each column
    |> Enum.sort(fn {p1, _}, {p2, _} -> length(p1) < length(p2) end)
    |> Enum.reduce(%{}, fn {plaus, i}, assigned ->
      Enum.reduce_while(plaus, assigned, fn p, ass ->
        if Map.has_key?(ass, p), do: {:cont, ass}, else: {:halt, Map.put(ass, p, i)}
      end)
    end)
    |> Enum.filter(fn {k, _v} -> String.starts_with?(k, "departure") end)
    |> Enum.map(fn {_k, v} -> Enum.at(my_ticket, v) end)
    |> Enum.reduce(&Kernel.*/2)
  end

  def parse_input(input) do
    # this parser function is disgusting, maybe refactor with nimbleparsec
    [fields, my_ticket, tickets] = String.split(input, "\n\n", trim: true)

    fields =
      fields
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [label, ranges] = String.split(line, ": ")
        [r1, r2] = String.split(ranges, " or ")
        [r1a, r1b] = String.split(r1, "-")
        [r2a, r2b] = String.split(r2, "-")

        {label, String.to_integer(r1a)..String.to_integer(r1b),
         String.to_integer(r2a)..String.to_integer(r2b)}
      end)

    [_, my_ticket] = String.split(my_ticket, "\n", trim: true)
    my_ticket = my_ticket |> String.split(",") |> Enum.map(&String.to_integer/1)

    [_ | tickets] = String.split(tickets, "\n", trim: true)

    tickets =
      tickets |> Enum.map(fn t -> t |> String.split(",") |> Enum.map(&String.to_integer/1) end)

    {fields, my_ticket, tickets}
  end
end
