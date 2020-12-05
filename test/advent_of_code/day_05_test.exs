defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  # @tag :skip
  test "part1" do
    assert "FBFBBFFRLR" |> String.codepoints() |> calc_seat_pos() == {44, 5}
    assert "BFFFBBFRRR" |> String.codepoints() |> calc_seat_pos() == {70, 7}
    assert "FFFBBBFRRR" |> String.codepoints() |> calc_seat_pos() == {14, 7}
    assert "BBFFBBFRLL" |> String.codepoints() |> calc_seat_pos() == {102, 4}
  end

  # no tests for p2
  # @tag :skip
  # test "part2" do
  # end
end
