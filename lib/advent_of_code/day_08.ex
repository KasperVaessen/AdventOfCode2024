defmodule AdventOfCode.Day08 do
  alias AdventOfCode.Grid

  def part1(args) do
    solve(args, &get_antinodes/2)
  end

  def part2(args) do
    solve(args, &get_antinodes2/2)
  end

  defp solve(args, node_fun) do
    grid = Grid.read_grid(args)

    Enum.flat_map(0..(grid.rows - 1), fn row ->
      Enum.map(0..(grid.rows - 1), &{Grid.get(grid, row, &1), {row, &1}})
    end)
    |> Enum.reject(fn {freq, _coor} -> freq == "." end)
    |> Enum.group_by(fn {freq, _coor} -> freq end, fn {_freq, coor} -> coor end)
    |> Map.values()
    |> Enum.map(&get_pairs/1)
    |> Enum.flat_map(&node_fun.(grid, &1))
    |> Enum.uniq()
    |> Enum.count(fn {x, y} -> x >= 0 and x < grid.rows and y >= 0 and y < grid.cols end)
  end

  defp get_pairs(list) do
    for x <- list, y <- list, x != y, do: [x, y]
  end

  defp get_antinodes(_grid, pairs) do
    Enum.flat_map(pairs, fn [{x1, y1}, {x2, y2}] ->
      diffx = x1 - x2
      diffy = y1 - y2

      [{x1 + diffx, y1 + diffy}, {x2 - diffx, y2 - diffy}]
    end)
  end

  defp get_antinodes2(grid, pairs) do
    Enum.flat_map(pairs, fn [{x1, y1}, {x2, y2}] ->
      diffx = x1 - x2
      diffy = y1 - y2

      get_positions(x1, y1, diffx, diffy, grid.rows, grid.cols, [{x1, y1}]) ++
        get_positions(x2, y2, -diffx, -diffy, grid.rows, grid.cols, [{x2, y2}])
    end)
  end

  defp get_positions(x, y, diffx, diffy, max_x, max_y, acc) do
    if x >= 0 and x < max_x and y >= 0 and y < max_y do
      new_x = x + diffx
      new_y = y + diffy

      acc = [{new_x, new_y} | acc]
      get_positions(new_x, new_y, diffx, diffy, max_x, max_y, acc)
    else
      acc
    end
  end
end
