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

  @spec read_grid(String.t(), String.t() | [String.t()] | nil) :: __MODULE__.t()
  def read_grid(input, sep) when is_binary(sep) do
    read_grid(input, sep, fn x -> x end)
  end

  @spec read_grid(String.t(), String.t() | [String.t()] | nil, fun()) :: __MODULE__.t()
  def read_grid(input, sep, mapper) do
    row_mapper =
      if sep do
        fn line -> String.split(line, sep, trim: true) |> Enum.map(&mapper.(&1)) end
      else
        fn line -> String.graphemes(line) |> Enum.map(&mapper.(&1)) end
      end

    data =
      input
      |> String.split(["\n", "\r", "\r\n"], trim: true)
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

  @spec get(__MODULE__.t(), {non_neg_integer(), non_neg_integer()}) :: any()
  def get(grid, {row, col}) do
    get(grid, row, col)
  end

  @spec set(__MODULE__.t(), {non_neg_integer(), non_neg_integer()}, any()) :: __MODULE__.t()
  def set(grid, {row, col}, value), do: set(grid, row, col, value)

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
          elem(grid.data, row)
          |> Tuple.to_list()
          |> List.replace_at(col, value)
          |> List.to_tuple()
        )
        |> List.to_tuple()

      %__MODULE__{rows: grid.rows, cols: grid.cols, data: data}
    end
  end

  @spec get_row(__MODULE__.t(), non_neg_integer()) :: list()
  def get_row(grid, row) do
    if row < 0 or row >= grid.rows do
      nil
    else
      elem(grid.data, row) |> Tuple.to_list()
    end
  end

  @spec get_col(__MODULE__.t(), non_neg_integer()) :: list()
  def get_col(grid, col) do
    if col < 0 or col >= grid.cols do
      nil
    else
      grid.data
      |> Tuple.to_list()
      |> Enum.map(&elem(&1, col))
    end
  end

  @spec find_pos(__MODULE__.t(), (any() -> boolean())) :: {non_neg_integer(), non_neg_integer()}
  def find_pos(grid, match_fun) do
    index = grid |> to_iterable() |> Enum.find_index(match_fun)

    if index do
      {div(index, grid.cols), rem(index, grid.cols)}
    end
  end

  @spec filter_rows(__MODULE__.t(), (tuple() -> boolean())) :: __MODULE__.t()
  def filter_rows(grid, filter_fun) do
    data =
      grid.data
      |> Tuple.to_list()
      |> Enum.filter(&filter_fun.(&1))
      |> List.to_tuple()

    cols =
      if tuple_size(data) > 0 do
        tuple_size(elem(data, 0))
      else
        0
      end

    %__MODULE__{cols: cols, rows: tuple_size(data), data: data}
  end

  @spec filter_cols(__MODULE__.t(), (tuple() -> boolean())) :: __MODULE__.t()
  def filter_cols(grid, filter_fun) do
    grid
    |> transpose()
    |> filter_rows(filter_fun)
    |> transpose()
  end

  @spec map(__MODULE__.t(), fun()) :: __MODULE__.t()
  def map(grid, map_func) do
    data =
      grid
      |> to_iterable()
      |> Enum.map(&map_func.(&1))
      |> Enum.chunk_every(grid.cols)
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple()

    %__MODULE__{data: data, rows: grid.rows, cols: grid.cols}
  end

  @spec transpose(__MODULE__.t()) :: __MODULE__.t()
  def transpose(grid) do
    if grid.rows == 0 or grid.cols == 0 do
      grid
    else
      data =
        grid.data
        |> Tuple.to_list()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.zip()
        |> List.to_tuple()

      %__MODULE__{rows: grid.cols, cols: grid.rows, data: data}
    end
  end

  @spec rotate_90(__MODULE__.t()) :: __MODULE__.t()
  def rotate_90(grid) do
    data =
      grid.data
      |> Tuple.to_list()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.reverse()
      |> Enum.zip()
      |> List.to_tuple()

    %__MODULE__{rows: grid.rows, cols: grid.cols, data: data}
  end

  @spec rotate_180(__MODULE__.t()) :: __MODULE__.t()
  def rotate_180(grid) do
    data =
      grid.data
      |> Tuple.to_list()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.reverse()
      |> Enum.map(&Enum.reverse/1)
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple()

    %__MODULE__{rows: grid.rows, cols: grid.cols, data: data}
  end

  @spec rotate_270(__MODULE__.t()) :: __MODULE__.t()
  def rotate_270(grid) do
    data =
      grid.data
      |> Tuple.to_list()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.zip()
      |> Enum.reverse()
      |> List.to_tuple()

    %__MODULE__{rows: grid.rows, cols: grid.cols, data: data}
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
    IO.puts(get_string(grid, spacer) <> "\n")
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

  @spec to_iterable(__MODULE__.t()) :: list(any())
  def to_iterable(grid) do
    grid.data
    |> Tuple.to_list()
    |> Enum.flat_map(&Tuple.to_list/1)
  end

  @spec to_lists(__MODULE__.t()) :: list(list(any()))
  def to_lists(grid) do
    grid.data
    |> Tuple.to_list()
    |> Enum.map(&Tuple.to_list/1)
  end
end
