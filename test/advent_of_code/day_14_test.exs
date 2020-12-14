defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.Day14

  @input """
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 165
  end

  # @tag :skip
  test "part2" do
    input = """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """

    assert part2(input) == 208
  end
end
