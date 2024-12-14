defmodule AdventOfCode.Day14 do
  def part1(args, width \\ 101, height \\ 103) do
    {robots, _variances} =
      args
      |> parse()
      |> move_robots(100, width, height, [])

    robots
    |> count_quadrants(width, height)
    |> Enum.product()
  end

  def part2(args, width \\ 101, height \\ 103) do
    {_robots, variances} =
      args
      |> parse()
      |> move_robots(10_000, width, height, [])

    dbg(length(variances))

    {_, index} =
      Enum.with_index(variances)
      |> Enum.min_by(fn {var, _index} -> var end)

    {robots, _variances} =
      args
      |> parse()
      |> move_robots(index + 1, width, height, [])

    print_robots(robots, width, height)

    index
  end

  defp count_quadrants(robots, width, height) do
    middle_x = floor(width / 2)
    middle_y = floor(height / 2)

    robots
    |> Enum.reduce([0, 0, 0, 0], fn {{x, y}, _}, [tl, tr, bl, br] ->
      case {x, y} do
        {x, y} when x < middle_x and y < middle_y ->
          [tl + 1, tr, bl, br]

        {x, y} when x > middle_x and y < middle_y ->
          [tl, tr + 1, bl, br]

        {x, y} when x < middle_x and y > middle_y ->
          [tl, tr, bl + 1, br]

        {x, y} when x > middle_x and y > middle_y ->
          [tl, tr, bl, br + 1]

        _ ->
          [tl, tr, bl, br]
      end
    end)
  end

  defp move_robots(robots, 0, _width, _height, variances), do: {robots, Enum.reverse(variances)}

  defp move_robots(robots, steps, width, height, variances) do
    robots = robots |> Enum.map(&move_robot(&1, width, height))
    variance = variance(robots)
    move_robots(robots, steps - 1, width, height, [variance | variances])
  end

  defp move_robot({{x, y}, {dir_x, dir_y}}, width, height) do
    new_x = Integer.mod(x + dir_x, width)
    new_y = Integer.mod(y + dir_y, height)

    {{new_x, new_y}, {dir_x, dir_y}}
  end

  defp parse(args) do
    args
    |> String.split(["\n", "\r", "\r\n"], trim: true)
    |> Enum.map(
      &Regex.named_captures(~r/p=(?<x>-*\d+),(?<y>-*\d+) v=(?<dir_x>-*\d+),(?<dir_y>-*\d+)/, &1)
    )
    |> Enum.map(fn %{"dir_x" => dir_x, "dir_y" => dir_y, "x" => x, "y" => y} ->
      {{String.to_integer(x), String.to_integer(y)},
       {String.to_integer(dir_x), String.to_integer(dir_y)}}
    end)
  end

  defp variance(robots) do
    x = Enum.map(robots, fn {{x, _}, _} -> x end)
    y = Enum.map(robots, fn {{_, y}, _} -> y end)

    n = length(robots)

    avg_x = Enum.sum(x) / n
    avg_y = Enum.sum(y) / n

    distances =
      Enum.zip(x, y)
      |> Enum.map(fn {x, y} -> :math.sqrt(:math.pow(x - avg_x, 2) + :math.pow(y - avg_y, 2)) end)
      |> Enum.sum()
  end

  defp print_robots(robots, width, height) do
    robots = robots |> Enum.map(fn {pos, _} -> pos end)

    grid =
      0..(height - 1)
      |> Enum.map(fn y ->
        Enum.map(
          0..(width - 1),
          fn x ->
            if Enum.member?(robots, {x, y}) do
              "#"
            else
              " "
            end
          end
        )
        |> Enum.join()
      end)
      |> Enum.join("\n")

    AdventOfCode.Grid.read_grid(grid) |> AdventOfCode.Grid.print()
  end
end
