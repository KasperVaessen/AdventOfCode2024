defmodule AdventOfCode.Day10 do
  alias AdventOfCode.Grid

  def part1(args) do
    grid = Grid.read_grid(args, &String.to_integer/1)

    Grid.find_all_pos(grid, &(&1 == 0))
    |> Enum.map(&length(calc_score(grid, &1, true)))
    |> Enum.sum()
  end

  def part2(args) do
    grid = Grid.read_grid(args, &String.to_integer/1)

    Grid.find_all_pos(grid, &(&1 == 0))
    |> Enum.map(&length(calc_score(grid, &1, false)))
    |> Enum.sum()
  end

  defp calc_score(grid, {x, y}, uniq?) do
    curr_val = Grid.get(grid, x, y)

    cond do
      curr_val == 9 ->
        [{x, y}]

      true ->
        res =
          [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
          |> Enum.filter(fn pos ->
            new_val = Grid.get(grid, pos)
            new_val != nil and new_val - curr_val == 1
          end)
          |> Enum.flat_map(&calc_score(grid, &1, uniq?))
          |> Enum.reject(&is_nil/1)

        if uniq? do
          Enum.uniq(res)
        else
          res
        end
    end
  end
end
