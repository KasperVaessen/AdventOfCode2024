defmodule AdventOfCode.Day03 do
  def part1(args) do
    Regex.scan(~r/mul\((?<d1>\d+),(?<d2>\d+)\)/, args, capture: ["d1", "d2"])
    |> Enum.map(fn [d1, d2] -> String.to_integer(d1) * String.to_integer(d2) end)
    |> Enum.sum()
  end

  def part2(args) do
    {val, _} =
      Regex.scan(~r/(?<d>do\(\))|(?<dn>don't\(\))|(mul\((?<d1>\d+),(?<d2>\d+)\))/, args,
        capture: ["d1", "d2", "d", "dn"]
      )
      |> Enum.reduce({0, true}, fn
        ["", "", "", "don't()"], {val, _status} ->
          {val, false}

        ["", "", "do()", ""], {val, _status} ->
          {val, true}

        [int1, int2, "", ""], {val, true} ->
          {val + String.to_integer(int1) * String.to_integer(int2), true}

        _, {val, status} ->
          {val, status}
      end)

    val
  end
end
