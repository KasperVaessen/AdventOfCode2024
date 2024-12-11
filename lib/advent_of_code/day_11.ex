defmodule AdventOfCode.Day11 do
  alias AdventOfCode.Grid

  def part1(args) do
    solve(args, 25)
  end

  def part2(args) do
    solve(args, 75)
  end

  defp solve(args, times) do
    counts = Grid.read_grid(args, " ") |> Grid.get_row(0) |> Enum.frequencies()

    Enum.reduce(1..times, counts, fn _, acc ->
      Enum.flat_map(acc, fn {num, count} ->
        new_nums = map_num(num)
        new_nums |> Enum.map(&{&1, count})
      end)
      |> Enum.reduce(%{}, fn {key, value}, acc ->
        Map.update(acc, key, value, &(&1 + value))
      end)
    end)
    |> Enum.reduce(0, fn {_, count}, acc -> acc + count end)
  end

  defp map_num(num) do
    cond do
      num == "0" ->
        ["1"]

      rem(len = String.length(num), 2) == 0 ->
        {num1, num2} = String.split_at(num, round(len / 2))
        ["#{String.to_integer(num1)}", "#{String.to_integer(num2)}"]

      true ->
        ["#{String.to_integer(num) * 2024}"]
    end
  end
end
