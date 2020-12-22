defmodule AdventOfCode.Day22 do
  def part1(input) do
    input
    |> parse_input()
    |> play()
    |> elem(1)
    |> calc_score()
  end

  def part2(input) do
    input
    |> parse_input()
    |> play_recursive(MapSet.new())
    |> elem(1)
    |> calc_score()
  end

  def parse_input(input) do
    [p1, p2] = String.split(input, "\n\n", trim: true)

    p1 = p1 |> String.split("\n", trim: true) |> Enum.drop(1) |> Enum.map(&String.to_integer/1)
    p2 = p2 |> String.split("\n", trim: true) |> Enum.drop(1) |> Enum.map(&String.to_integer/1)

    {p1, p2}
  end

  def play({deck1, []}), do: {:p1, deck1}
  def play({[], deck2}), do: {:p2, deck2}

  def play({[card1 | rest1], [card2 | rest2]}) do
    cond do
      card1 > card2 -> play({rest1 ++ [card1, card2], rest2})
      card1 < card2 -> play({rest1, rest2 ++ [card2, card1]})
    end
  end

  def play_recursive({deck1, []}, _), do: {:p1, deck1}
  def play_recursive({[], deck2}, _), do: {:p2, deck2}

  def play_recursive(decks = {[card1 | rest1], [card2 | rest2]}, played) do
    cond do
      decks in played ->
        {:p1, elem(decks, 0)}

      card1 <= length(rest1) and card2 <= length(rest2) ->
        new1 = Enum.take(rest1, card1)
        new2 = Enum.take(rest2, card2)

        case play_recursive({new1, new2}, MapSet.new()) do
          {:p1, _} -> play_recursive({rest1 ++ [card1, card2], rest2}, MapSet.put(played, decks))
          {:p2, _} -> play_recursive({rest1, rest2 ++ [card2, card1]}, MapSet.put(played, decks))
        end

      card1 > card2 ->
        play_recursive({rest1 ++ [card1, card2], rest2}, MapSet.put(played, decks))

      card1 < card2 ->
        play_recursive({rest1, rest2 ++ [card2, card1]}, MapSet.put(played, decks))
    end
  end

  def calc_score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {card, i}, acc -> card * i + acc end)
  end
end
