defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  @input """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 11
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 6
  end
end
