defmodule AdventOfCode.Day04 do
  alias AdventOfCode.Grid

  def part1(args) do
    grid = Grid.read_grid(args)

    grid
    |> Grid.to_iterable()
    |> Enum.with_index()
    |> Enum.map(fn
      {"X", i} -> {div(i, grid.cols), rem(i, grid.cols)}
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&get_amount_xmas_at(grid, &1))
    |> Enum.sum()
  end

  def part2(args) do
    grid = Grid.read_grid(args)

    grid
    |> Grid.to_iterable()
    |> Enum.with_index()
    |> Enum.map(fn
      {"A", i} -> {div(i, grid.cols), rem(i, grid.cols)}
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&is_x_mas_at?(grid, &1))
    |> Enum.count(& &1)
  end

  defp get_amount_xmas_at(grid, {x, y}) do
    [
      [{x, y}, {x + 1, y}, {x + 2, y}, {x + 3, y}],
      [{x, y}, {x - 1, y}, {x - 2, y}, {x - 3, y}],
      [{x, y}, {x, y + 1}, {x, y + 2}, {x, y + 3}],
      [{x, y}, {x, y - 1}, {x, y - 2}, {x, y - 3}],
      [{x, y}, {x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}],
      [{x, y}, {x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}],
      [{x, y}, {x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3}],
      [{x, y}, {x - 1, y - 1}, {x - 2, y - 2}, {x - 3, y - 3}]
    ]
    |> Enum.count(fn list ->
      Enum.map(list, &Grid.get(grid, &1)) == ["X", "M", "A", "S"]
    end)
  end

  defp is_x_mas_at?(grid, {x, y}) do
    surrounding = Grid.get_surrounding(grid, x, y)

    letters =
      [{0, 0}, {0, 2}, {2, 0}, {2, 2}]
      |> Enum.map(&Grid.get(surrounding, &1))

    freqs =
      letters
      |> Enum.frequencies()

    letters = List.to_tuple(letters)

    freqs["M"] == 2 and
      freqs["S"] == 2 and
      elem(letters, 0) != elem(letters, 3)
  end
end
