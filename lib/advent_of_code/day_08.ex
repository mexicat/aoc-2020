defmodule AdventOfCode.Day08 do
  defstruct at: 0, acc: 0, ops: [], hist: []

  def part1(input) do
    {:error, acc} =
      input
      |> String.split("\n", trim: true)
      |> new()
      |> run()

    acc
  end

  def part2(input) do
    bootcode =
      input
      |> String.split("\n", trim: true)
      |> new()

    run_2(bootcode, bootcode)
  end

  def new(ops) do
    %__MODULE__{ops: ops}
  end

  def run(bootcode = %{at: at, acc: acc, ops: ops, hist: hist}) do
    cond do
      # already visited, prevent infinite loop
      at in hist ->
        {:error, acc}

      # next index over the length of ops, finished
      at >= Enum.count(ops) ->
        {:done, acc}

      true ->
        {cmd, arg} = ops |> Enum.at(at) |> parse_command()
        new_bootcode = command(bootcode, cmd, arg)
        run(%{new_bootcode | hist: [at | hist]})
    end
  end

  def run_2(bootcode, original_bootcode, edited \\ 0) do
    case run(bootcode) do
      {:done, acc} ->
        acc

      {:error, _} ->
        new_ops = change_ops(original_bootcode.ops, edited + 1)
        run_2(%{bootcode | ops: new_ops}, original_bootcode, edited + 1)
    end
  end

  def parse_command(cmd) do
    [c, arg] = String.split(cmd)
    {c, String.to_integer(arg)}
  end

  def command(bootcode = %{acc: acc, at: at}, "acc", x) do
    %{bootcode | acc: acc + x, at: at + 1}
  end

  def command(bootcode = %{at: at}, "jmp", x) do
    %{bootcode | at: at + x}
  end

  def command(bootcode = %{at: at}, "nop", _) do
    %{bootcode | at: at + 1}
  end

  def change_ops(ops, edited) do
    # this is ugly, i'm embarassed
    {to_replace, index} =
      ops
      |> Enum.with_index()
      |> Enum.filter(fn {op, _} ->
        String.starts_with?(op, "jmp") or String.starts_with?(op, "nop")
      end)
      |> Enum.at(edited - 1)

    replaced =
      if String.starts_with?(to_replace, "jmp"),
        do: String.replace(to_replace, "jmp", "nop"),
        else: String.replace(to_replace, "nop", "jmp")

    List.replace_at(ops, index, replaced)
  end
end
