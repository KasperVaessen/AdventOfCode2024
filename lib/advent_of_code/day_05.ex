defmodule AdventOfCode.Day05 do
  def part1(args) do
    [rules, instructions] = String.split(args, ["\n\n", "\r\r", "\r\n\r\n"], trim: true)

    rules =
      rules
      |> String.split(["\n", "\r", "\r\n"], trim: true)
      |> MapSet.new()

    instructions =
      instructions
      |> String.split(["\n", "\r", "\r\n"], trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))

    instructions_sorted =
      instructions
      |> Enum.map(
        &Enum.sort_by(&1, fn elem -> elem end, fn elem1, elem2 ->
          key = "#{elem1}|#{elem2}"
          MapSet.member?(rules, key)
        end)
      )

    Enum.zip(instructions, instructions_sorted)
    |> Enum.filter(fn {list1, list2} -> list1 == list2 end)
    |> Enum.map(fn {_, list} -> Enum.at(list, div(length(list), 2)) |> String.to_integer() end)
    |> Enum.sum()
  end

  def part2(args) do
    [rules, instructions] = String.split(args, ["\n\n", "\r\r", "\r\n\r\n"], trim: true)

    rules =
      rules
      |> String.split(["\n", "\r", "\r\n"], trim: true)
      |> MapSet.new()

    instructions =
      instructions
      |> String.split(["\n", "\r", "\r\n"], trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))

    instructions_sorted =
      instructions
      |> Enum.map(
        &Enum.sort_by(&1, fn elem -> elem end, fn elem1, elem2 ->
          key = "#{elem1}|#{elem2}"
          MapSet.member?(rules, key)
        end)
      )

    Enum.zip(instructions, instructions_sorted)
    |> Enum.filter(fn {list1, list2} -> list1 != list2 end)
    |> Enum.map(fn {_, list} -> Enum.at(list, div(length(list), 2)) |> String.to_integer() end)
    |> Enum.sum()
  end
end
