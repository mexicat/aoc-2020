defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  @input """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 37
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 26
  end
end
