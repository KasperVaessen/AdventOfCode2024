defmodule AdventOfCode.Day09 do
  alias AdventOfCode.Grid

  def part1(args) do
    [first | list] = args |> Grid.read_grid(&String.to_integer/1) |> Grid.to_iterable()

    files = Enum.take_every([first | list], 2) |> Enum.with_index()
    empty = Enum.take_every(list, 2) |> Enum.map(&{&1, nil})

    counts = merge(files, empty)

    move_to_start(counts)
    |> Enum.reject(fn {_, file} -> is_nil(file) end)
    |> check_sum(0, 0)
  end

  def part2(args) do
    # [first | list] = args |> Grid.read_grid(&String.to_integer/1) |> Grid.to_iterable()

    # files = Enum.take_every([first | list], 2) |> Enum.with_index()
    # empty = Enum.take_every(list, 2) |> Enum.map(&{&1, nil})

    # counts = merge(files, empty)
  end

  defp check_sum([], _, sum) do
    sum
  end

  defp check_sum(counts, index, sum) do
    [{count, file} | rest] = counts
    new_sum = Enum.map(index..(index + count - 1), &(&1 * file)) |> Enum.sum()
    check_sum(rest, index + count, sum + new_sum)
  end

  defp move_to_start(counts) do
    counts = Enum.reject(counts, fn {amount, _} -> amount == 0 end)

    if is_done?(counts) do
      counts
    else
      {{amount, file}, counts} = List.pop_at(counts, -1)

      if is_nil(file) do
        move_to_start(counts)
      else
        {counts, remainder} =
          Enum.flat_map_reduce(counts, amount, fn
            {amount2, file2}, acc when acc == 0 or is_integer(file2) ->
              {[{amount2, file2}], acc}

            {amount2, nil}, acc when acc >= amount2 ->
              {[{amount2, file}], acc - amount2}

            {amount2, nil}, acc when acc < amount2 ->
              {[{acc, file}, {amount2 - acc, nil}], 0}
          end)

        if remainder > 0 do
          move_to_start(counts ++ [{remainder, file}])
        else
          move_to_start(counts)
        end
      end
    end
  end

  defp is_done?(counts) do
    {_non_nils, trailing_nils} = Enum.split_while(counts, fn {_, file} -> file != nil end)
    Enum.empty?(trailing_nils) or Enum.all?(trailing_nils, fn {_, file} -> file == nil end)
  end

  defp print_test(list) do
    Enum.reduce(list, "", fn {count, elem}, acc -> acc <> String.duplicate("#{elem}", count) end)
    |> IO.puts()

    list
  end

  def merge([], b), do: b
  def merge(a, []), do: a

  def merge([head_a | tail_a], [head_b | tail_b]) do
    [head_a, head_b | merge(tail_a, tail_b)]
  end
end
