defmodule AdventOfCode.Grid do
  defstruct rows: 0, cols: 0, data: nil

  @type t :: %__MODULE__{
          rows: non_neg_integer(),
          cols: non_neg_integer(),
          data: tuple()
        }

  @spec read_grid(String.t()) :: __MODULE__.t()
  def read_grid(input) do
    read_grid(input, nil, fn x -> x end)
  end

  @spec read_grid(String.t(), fun()) :: __MODULE__.t()
  def read_grid(input, mapper) when is_function(mapper) do
    read_grid(input, nil, mapper)
  end

  @spec read_grid(String.t(), String.t() | nil) :: __MODULE__.t()
  def read_grid(input, sep) when is_binary(sep) do
    read_grid(input, sep, fn x -> x end)
  end

  @spec read_grid(String.t(), String.t() | nil, fun()) :: __MODULE__.t()
  def read_grid(input, sep, mapper) do
    row_mapper =
      if sep do
        fn line -> String.split(line, sep, trim: true) |> Enum.map(&mapper.(&1)) end
      else
        fn line -> String.graphemes(line) |> Enum.map(&mapper.(&1)) end
      end

    data =
      input
      |> String.split("\n", trim: false)
      |> Enum.map(&row_mapper.(&1))
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple()

    %__MODULE__{rows: tuple_size(data), cols: tuple_size(elem(data, 0)), data: data}
  end

  @spec get(__MODULE__.t(), non_neg_integer(), non_neg_integer()) :: any()
  def get(grid, row, col) do
    if row < 0 or row >= grid.rows or col < 0 or col >= grid.cols do
      nil
    else
      elem(elem(grid.data, row), col)
    end
  end

  @spec set(__MODULE__.t(), non_neg_integer(), non_neg_integer(), any()) ::
          __MODULE__.t()
  def set(grid, row, col, value) do
    if row < 0 or row >= grid.rows or col < 0 or col >= grid.cols do
      grid
    else
      data =
        grid.data
        |> Tuple.to_list()
        |> List.replace_at(
          row,
          elem(grid.data, row) |> Tuple.to_list() |> List.replace_at(col, value)
        )
        |> List.to_tuple()

      %__MODULE__{rows: grid.rows, cols: grid.cols, data: data}
    end
  end

  @spec get_string(__MODULE__.t(), String.t()) :: String.t()
  def get_string(grid, spacer \\ "") do
    grid.data
    |> Tuple.to_list()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join(&1, spacer))
    |> Enum.join("\n")
  end

  @spec print(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def print(grid, spacer \\ "") do
    IO.puts(get_string(grid, spacer))
    grid
  end

  @spec get_surrounding(__MODULE__.t(), non_neg_integer(), non_neg_integer()) :: __MODULE__.t()
  def get_surrounding(grid, row, col) do
    data =
      [
        {row - 1, col - 1},
        {row - 1, col},
        {row - 1, col + 1},
        {row, col - 1},
        {row, col},
        {row, col + 1},
        {row + 1, col - 1},
        {row + 1, col},
        {row + 1, col + 1}
      ]
      |> Enum.map(fn {r, c} -> get(grid, r, c) end)
      |> Enum.chunk_every(3)
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple()

    %__MODULE__{rows: 3, cols: 3, data: data}
  end

  @spec to_iterable(__MODULE__.t()) :: list()
  def to_iterable(grid) do
    grid.data
    |> Tuple.to_list()
    |> Enum.flat_map(&Tuple.to_list/1)
  end
end
