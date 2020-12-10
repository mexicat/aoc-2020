defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  @input1 """
  16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4
  """

  @input2 """
  28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3
  """

  # @tag :skip
  test "part1" do
    assert part1(@input2) == 220
  end

  # @tag :skip
  test "part2" do
    assert part2(@input1) == 8
    assert part2(@input2) == 19208
  end
end
