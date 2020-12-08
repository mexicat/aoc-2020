defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  @input """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 5
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 8
  end
end
