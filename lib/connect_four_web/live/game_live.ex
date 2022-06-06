defmodule ConnectFourWeb.GameLive do
  use Phoenix.LiveView, layout: {ConnectFourWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    board = ConnectFour.Cell.new_board()
    color_map = %{:empty => "white-token", :black => "black-token", :red => "red-token"}
    socket = assign(socket, :board, board)
    socket = assign(socket, :color_map, color_map)
    socket = assign(socket, :player1, "player 1")
    socket = assign(socket, :player2, "player 2")
    {:noreply, put_flash(socket, :info, "ABCD")}
    Phoenix.PubSub.subscribe(ConnectFour.PubSub, "game")
    {:ok, socket}
  end

  def get_cell(board, row, col) do
    board |> Map.get(%ConnectFour.Cell{col: col, row: row})
  end

  def handle_info({:board, board}, socket) do
    {:noreply, assign(socket, :board, board)}
  end

  def handle_info({:players, player1, player2}, socket) do
    socket = assign(socket, :player1, player1)
    socket = assign(socket, :player2, player2)
    {:noreply, socket}
  end

  def handle_info({:winner, {_color, player}}, socket) do
    {:noreply, put_flash(socket, :info, "Player #{player} wins")}
  end

  def handle_info({:winner, :tie}, socket) do
    {:noreply, put_flash(socket, :info, "It was a tie")}
  end

  def render(assigns) do
    ~H"""
    <div class="game">
      <div class="player"><p><%= Macro.camelize(@player1) %></p></div>
      <div class="board">
      <%= for row <- ConnectFour.Cell.rows do %>
        <%= for col <- ConnectFour.Cell.columns do %>
          <div class="cell">
            <div class={@color_map[get_cell(@board, row, col)]}></div>
          </div>
        <% end %>
      <% end %>
      </div>
      <div class="player"><p><%= Macro.camelize(@player2) %></p></div>
    </div>
    """
  end
end
