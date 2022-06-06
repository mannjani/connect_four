defmodule ConnectFour.Cell do
  alias ConnectFour.Cell
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @columns 1..7
  @rows 1..6

  def new(col, row) when col in @columns and row in @rows do
    {:ok, %Cell{row: row, col: col}}
  end

  def new(_col, _row) do
    {:error, :invalid_cell}
  end

  def new_board() do
    for s <- cells(), into: %{} do
      {s, :empty}
    end
  end

  def cells() do
    for c <- @columns, r <- @rows, into: MapSet.new() do
      %Cell{col: c, row: r}
    end
  end

  def columns() do
    @columns
  end

  def rows() do
    @rows
  end

  def gather_values(board, {r, c}, {deltar, deltac}, l) do
    cell = %Cell{col: c, row: r}
    value = board |> Map.get(cell)

    case value do
      nil -> l
      _ -> gather_values(board, {r + deltar, c + deltac}, {deltar, deltac}, [value | l])
    end
  end

  def row_values(board) do
    for r <- @rows do
      gather_values(board, {r, 1}, {0, 1}, [])
    end
  end

  def column_values(board) do
    for c <- @columns do
      gather_values(board, {1, c}, {1, 0}, [])
    end
  end

  def diagonal_values(board) do
    up_pairs = [{4, 1}, {5, 1}, {6, 1}, {6, 2}, {6, 3}, {6, 4}]

    u =
      for p <- up_pairs do
        gather_values(board, p, {-1, 1}, [])
      end

    down_pairs = [{1, 4}, {1, 3}, {1, 2}, {1, 1}, {2, 1}, {3, 1}]

    d =
      for p <- down_pairs do
        gather_values(board, p, {1, 1}, [])
      end

    u ++ d
  end
end
