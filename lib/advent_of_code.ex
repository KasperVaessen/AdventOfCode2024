defmodule AdventOfCode do
  alias AdventOfCode.Graph
  alias AdventOfCode.Grid

  @moduledoc """
  Documentation for AdventOfCode.
  """

  def test_dijkstra() do
    grid =
      "00000\n00000\n00000\n00010"
      |> Grid.read_grid()
      |> Grid.print("\t")

    start_pos = {0, 0}

    neighbour_func = fn {x, y} ->
      [
        {1.414, {x + 1, y + 1}},
        {1.414, {x - 1, y + 1}},
        {1.414, {x - 1, y - 1}},
        {1.414, {x + 1, y - 1}},
        {1, {x + 1, y}},
        {1, {x, y + 1}},
        {1, {x - 1, y}},
        {1, {x, y - 1}}
      ]
      |> Enum.filter(fn {_, {x, y}} -> x >= 0 and y >= 0 and x < grid.cols and y < grid.rows end)
    end

    success_func = fn {x, y} -> Grid.get(grid, x, y) == "1" end

    Graph.dijkstra(start_pos, neighbour_func, success_func) |> dbg()
  end

  def test_transpose() do
    grid =
      "00000\n00000\n00000\n00010"
      |> Grid.read_grid()
      |> Grid.print("\t")

    grid
    |> Grid.transpose()
    |> Grid.print("\t")
  end

  def test_rotate() do
    IO.puts("Rotate 0 degrees")

    grid =
      "123\n456\n789"
      |> Grid.read_grid()
      |> Grid.print("\t")

    IO.puts("Rotate 90 degrees")

    grid
    |> Grid.rotate_90()
    |> Grid.print("\t")

    IO.puts("Rotate 180 degrees")

    grid
    |> Grid.rotate_180()
    |> Grid.print("\t")

    IO.puts("Rotate 270 degrees")

    grid
    |> Grid.rotate_270()
    |> Grid.print("\t")
  end
end
