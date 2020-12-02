defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  @input """
  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 2
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 1
  end
end
