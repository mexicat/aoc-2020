defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  # @tag :skip
  test "part1" do
    input = "0,3,6"
    assert part1(input) == 436
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
