defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @input """
  F10
  N3
  F7
  R90
  F11
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 25
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 286
  end
end
