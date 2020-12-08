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
    %__MODULE__{ops: Enum.map(ops, &parse_command/1)}
  end

  def run(bootcode = %{at: at, acc: acc, ops: ops, hist: hist}) do
    cond do
      # already visited: stop to prevent infinite loop
      at in hist ->
        {:error, acc}

      # next index over the length of ops: finished
      at >= length(ops) ->
        {:done, acc}

      true ->
        new_bootcode = command(bootcode, Enum.at(ops, at))
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
    {String.to_atom(c), String.to_integer(arg)}
  end

  def command(bootcode = %{acc: acc, at: at}, {:acc, x}) do
    %{bootcode | acc: acc + x, at: at + 1}
  end

  def command(bootcode = %{at: at}, {:jmp, x}) do
    %{bootcode | at: at + x}
  end

  def command(bootcode = %{at: at}, {:nop, _}) do
    %{bootcode | at: at + 1}
  end

  def change_ops(ops, edited) do
    {to_replace, index} =
      ops
      |> Enum.with_index()
      |> Enum.filter(fn {{op, _}, _} ->
        op == :jmp or op == :nop
      end)
      |> Enum.at(edited - 1)

    List.replace_at(ops, index, replace_op(to_replace))
  end

  def replace_op({:jmp, x}), do: {:nop, x}
  def replace_op({:nop, x}), do: {:jmp, x}
end
