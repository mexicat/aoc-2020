defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  @input """
  939
  7,13,x,x,59,x,31,19
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 295
  end

  # @tag :skip
  test "part2" do
    assert part2("0\n17,x,13,19") == 3417
    # assert part2(@input) == 1068781
  end
end
