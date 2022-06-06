defmodule ConnectFour.Game do
  alias ConnectFour.Game
  defstruct [:black, :red, turn: :black, board: ConnectFour.Cell.new_board(), winner: nil]

  def new(player1, player2) do
    {:ok, p1} = ConnectFour.Player.new(player1, :black, true)
    {:ok, p2} = ConnectFour.Player.new(player2, :red, true)
    game = %Game{black: p1, red: p2}

    Phoenix.PubSub.broadcast(ConnectFour.PubSub, "game", {:players, player1, player2})
    Phoenix.PubSub.broadcast(ConnectFour.PubSub, "game", {:board, game.board})

    Task.start_link(fn -> play_game(game) end)
  end

  defp switch_player(p) do
    case p do
      :black -> :red
      :red -> :black
    end
  end

  defp play_game(game) do
    game =
      with player <- Map.get(game, game.turn),
           play_column <- player.code.(game.board),
           new_board <- ConnectFour.play_at(game.board, play_column, game.turn) do
        %Game{game | board: new_board, turn: switch_player(game.turn)}
      end

    Phoenix.PubSub.broadcast(ConnectFour.PubSub, "game", {:board, game.board})

    case check_game_over(game.board) do
      :black ->
        player = Map.get(game, :black)

        Phoenix.PubSub.broadcast(
          ConnectFour.PubSub,
          "game",
          {:winner, {:black, player.name}}
        )

      :red ->
        player = Map.get(game, :red)

        Phoenix.PubSub.broadcast(
          ConnectFour.PubSub,
          "game",
          {:winner, {:red, player.name}}
        )

      :tie ->
        Phoenix.PubSub.broadcast(
          ConnectFour.PubSub,
          "game",
          {:winner, :tie}
        )

      _ ->
        play_game(game)
    end
  end

  def sublist?([], _), do: false

  def sublist?(l1, l2) when length(l1) < length(l2), do: false

  def sublist?(l1 = [_ | t], l2) do
    List.starts_with?(l1, l2) or sublist?(t, l2)
  end

  def is_board_full?(board) do
    empty_cells =
      board
      |> Map.filter(fn {_, value} -> value == :empty end)

    case map_size(empty_cells) do
      0 -> :tie
      _ -> nil
    end
  end

  def series_win(series) do
    try do
      for s <- series do
        case sublist?(s, [:black, :black, :black, :black]) do
          true -> throw(:black)
          false -> nil
        end

        case sublist?(s, [:red, :red, :red, :red]) do
          true -> throw(:red)
          false -> nil
        end
      end

      nil
    catch
      :black -> :black
      :red -> :red
    end
  end

  def check_game_over(board) do
    series_win(ConnectFour.Cell.row_values(board)) ||
      series_win(ConnectFour.Cell.column_values(board)) ||
      series_win(ConnectFour.Cell.diagonal_values(board)) ||
      is_board_full?(board)
  end
end
