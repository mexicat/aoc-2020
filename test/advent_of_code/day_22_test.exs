defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  @input """
  Player 1:
  9
  2
  6
  3
  1

  Player 2:
  5
  8
  4
  7
  10
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 306
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 291
  end
end
