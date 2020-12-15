defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  # @tag :skip
  test "part1" do
    assert part1("0,3,6") == 436
  end

  # @tag :skip
  test "part2" do
    assert part2("0,3,6") == 175594
    assert part2("1,3,2") == 2578
  end
end
