defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @input """
  2333133121414131402
  """

  @input2 """
  12345
  """

  @input3 """
  1111111111111111111111
  """

  @input4 """
  90909
  """

  @inter """
  000000000111111111222222222
  """

  test "part1" do
    result = part1(@input)

    assert result == 1928
  end

  test "part1_2" do
    result = part1(@input2)

    assert result == 60
  end

  test "part1_3" do
    result = part1(@input3)

    assert result == 290
  end

  test "part1_4" do
    result = part1(@input4)

    should_be =
      Enum.zip(
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2],
        0..26
      )
      |> Enum.map(fn {a, b} -> a * b end)
      |> Enum.sum()

    assert result == should_be
  end

  test "part2" do
    result = part2(@input)

    assert result == 2858
  end
end
