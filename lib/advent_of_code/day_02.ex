defmodule AdventOfCode.Day02 do
  alias AdventOfCode.Grid

  def part1(args) do
    grid = Grid.read_grid(args, " ", &String.to_integer/1)

    0..(grid.rows - 1)
    |> Enum.map(fn i ->
      row = Grid.get_row(grid, i)
      is_safe(row)
    end)
    |> Enum.count(& &1)
  end

  def part2(args) do
    grid = Grid.read_grid(args, " ", &String.to_integer/1)

    0..(grid.rows - 1)
    |> Enum.map(fn i ->
      row = Grid.get_row(grid, i)
      len = length(row)
      options = 0..(len - 1) |> Enum.map(&List.delete_at(row, &1))
      Enum.any?(options, &is_safe(&1))
    end)
    |> Enum.count(& &1)
  end

  defp is_safe(row) do
    ordered = row == Enum.sort(row) or row == Enum.sort(row, :desc)

    windows = Enum.chunk_every(row, 2, 1, :discard)
    small_steps = Enum.all?(windows, fn [num1, num2] -> abs(num1 - num2) in [1, 2, 3] end)

    ordered and small_steps
  end
end
