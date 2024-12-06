defmodule AdventOfCode.Day06 do
  alias AdventOfCode.Grid

  def part1(args) do
    grid = Grid.read_grid(args)
    length(solve(grid))
  end

  def part2(args) do
    grid = Grid.read_grid(args)
    [_ | possible_positions] = solve(grid)

    Enum.count(possible_positions, fn pos ->
      solve(grid, pos) == :looping
    end)
  end

  defp solve(grid, extra_bar \\ nil) do
    start_pos = Grid.find_pos(grid, &(&1 in ["^", "<", ">", "v"]))
    current_dir = dir(Grid.get(grid, start_pos))
    grid = Grid.set(grid, start_pos, ".")
    visited = MapSet.new()

    take_step(grid, start_pos, current_dir, visited, extra_bar)
  end

  defp take_step(grid, {pos_row, pos_col} = pos, {dir_row, dir_col} = dir, visited, extra_bar) do
    looping? = MapSet.member?(visited, {pos, dir})
    visited = MapSet.put(visited, {pos, dir})

    new_pos = {pos_row + dir_row, pos_col + dir_col}
    new_val = Grid.get(grid, new_pos)

    cond do
      looping? ->
        :looping

      new_val == "#" or new_pos == extra_bar ->
        take_step(grid, pos, turn(dir), visited, extra_bar)

      new_val == "." ->
        take_step(grid, new_pos, dir, visited, extra_bar)

      new_val == nil ->
        visited
        |> MapSet.to_list()
        |> Enum.map(fn {pos, _dir} -> pos end)
        |> Enum.uniq()
    end
  end

  defp dir("^"), do: {-1, 0}
  defp dir("v"), do: {1, 0}
  defp dir(">"), do: {0, 1}
  defp dir("<"), do: {0, -1}

  defp turn({row, col}), do: {col, -row}
end
