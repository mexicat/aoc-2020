defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @input """
  1721
  979
  366
  299
  675
  1456
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 514_579
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 241_861_950
  end
end
