defmodule AdventOfCode.Day01 do
  alias AdventOfCode.Grid

  def part1(args) do
    grid = Grid.read_grid(args, " ", &String.to_integer/1)
    list1 = Grid.get_col(grid, 0) |> Enum.sort()
    list2 = Grid.get_col(grid, 1) |> Enum.sort()

    Enum.zip(list1, list2) |> Enum.reduce(0, fn {num1, num2}, acc -> acc + abs(num1 - num2) end)
  end

  def part2(args) do
    grid = Grid.read_grid(args, " ", &String.to_integer/1)
    list1 = Grid.get_col(grid, 0)
    freqs = Grid.get_col(grid, 1) |> Enum.frequencies()

    Enum.reduce(list1, 0, &(&2 + (freqs[&1] || 0) * &1))
  end
end
