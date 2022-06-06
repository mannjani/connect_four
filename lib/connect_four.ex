defmodule ConnectFour do
  @moduledoc """
  ConnectFour keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def check_player(player) do
    case player do
      :black -> {:ok, player}
      :red -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  def place_token(board, place, player) do
    case board[place] do
      nil -> {:error, :invalid_location}
      :red -> {:error, :occupied}
      :black -> {:error, :occupied}
      :empty -> {:ok, %{board | place => player}}
    end
  end

  def bottom_cell(board, column) do
    row =
      board
      |> Map.filter(fn {cell, _} -> cell.col == column end)
      |> Map.filter(fn {_, value} -> value == :empty end)
      |> Map.keys()
      |> Enum.map(& &1.row)
      |> Enum.max(fn -> -1 end)

    ConnectFour.Cell.new(column, row)
  end

  def play_at(board, column, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, cell} <- bottom_cell(board, column),
         {:ok, updated_board} <- place_token(board, cell, valid_player) do
      updated_board
    end
  end
end
