defmodule AdventOfCode.Day07 do
  alias AdventOfCode.Grid

  def part1(args) do
    Grid.read_grid(args, [" ", ": "], &String.to_integer/1)
    |> Grid.to_lists()
    |> Enum.filter(&has_solution/1)
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end

  def part2(args) do
    Grid.read_grid(args, [" ", ": "], &String.to_integer/1)
    |> Grid.to_lists()
    |> Enum.filter(&has_solution(&1, true))
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end

  defp has_solution(list, concat? \\ false) do
    case list do
      [total, res] ->
        total == res

      [total, a | _rest] when a > total ->
        false

      [total, a, b | rest] ->
        mult = a * b
        plus = a + b
        conc = String.to_integer("#{a}#{b}")

        has_solution([total, mult | rest], concat?) or
          has_solution([total, plus | rest], concat?) or
          (concat? and has_solution([total, conc | rest], concat?))
    end
  end
end
