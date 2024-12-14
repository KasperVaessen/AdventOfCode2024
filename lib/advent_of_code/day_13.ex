defmodule AdventOfCode.Day13 do
  def part1(args) do
    solve(args, false)
  end

  def part2(args) do
    solve(args, true)
  end

  def solve(args, part2?) do
    args
    |> String.split(["\n\n", "\r\r", "\r\n\r\n"], trim: true)
    |> Enum.map(&String.split(&1, ["\n", "\r", "\r\n"], trim: true))
    |> Enum.map(fn game ->
      Enum.map(game, fn line ->
        Regex.named_captures(~r/.+?(?<num1>\d+).+?(?<num2>\d+)/, line)
      end)
    end)
    |> Enum.map(&calc_solution(&1, part2?))
    |> Enum.reject(&is_nil/1)
    |> Enum.sum()
  end

  defp calc_solution([
         %{"num1" => a, "num2" => d},
         %{"num1" => b, "num2" => e},
         %{"num1" => c, "num2" => f}
       ], part2?) do
    calc_solution(
      String.to_integer(a),
      String.to_integer(b),
      String.to_integer(c),
      String.to_integer(d),
      String.to_integer(e),
      String.to_integer(f),
      part2?
    )
  end

  defp calc_solution(a, b, c, d, e, f, part2?) do
    {c,f} = if part2? do
      {c + 10_000_000_000_000, f + 10_000_000_000_000}
    else
      {c,f}
    end


    y = (f * a - d * c) / (e * a - b * d)
    x = (c - b * y) / a

    x_trunc = trunc(x)
    y_trunc = trunc(y)

    if x_trunc == x and y_trunc == y do
      x_trunc * 3 + y_trunc
    end
  end
end
