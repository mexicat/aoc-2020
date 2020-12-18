defmodule AdventOfCode.Day18 do
  def part1(input) do
    input
    |> change_operators()
    |> String.split("\n", trim: true)
    |> Enum.map(fn expr ->
      {res, _} =
        expr |> Code.string_to_quoted!() |> in_module(SimpleOperators) |> Code.eval_quoted()

      res
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> change_operators_2()
    |> String.split("\n", trim: true)
    |> Enum.map(fn expr ->
      {res, _} =
        expr |> Code.string_to_quoted!() |> in_module(AdvancedOperators) |> Code.eval_quoted()

      res
    end)
    |> Enum.sum()
  end

  def in_module(ast, mod) do
    quote do
      import unquote(mod)
      import Kernel, only: []
      unquote(ast)
    end
  end

  def change_operators(input) do
    input
    |> String.replace("+", ">>>")
    |> String.replace("-", "<<<")
    |> String.replace("*", "~>>")
    |> String.replace("/", "<<~")
  end

  def change_operators_2(input) do
    input
    |> String.replace("*", "~>>")
    |> String.replace("/", "<<~")
  end
end

defmodule SimpleOperators do
  def a >>> b, do: a + b
  def a <<< b, do: a - b
  def a ~>> b, do: a * b
  def a <<~ b, do: div(a, b)
end

defmodule AdvancedOperators do
  # needed because i remove the imports in `in_module`
  import Kernel, except: [+: 2, -: 2]

  def a + b, do: Kernel.+(a, b)
  def a - b, do: Kernel.-(a, b)
  def a ~>> b, do: a * b
  def a <<~ b, do: div(a, b)
end
