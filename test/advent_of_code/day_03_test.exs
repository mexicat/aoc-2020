defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  @input """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 7
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 336
  end
end
