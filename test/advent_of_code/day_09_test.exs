defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @input """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """

  # @tag :skip
  test "part1" do
    assert part1(@input, 5) == 127
  end

  # @tag :skip
  test "part2" do
    assert part2(@input, 5) == 62
  end
end
