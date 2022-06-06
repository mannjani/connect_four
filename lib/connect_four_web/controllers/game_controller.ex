defmodule ConnectFourWeb.GameController do
  use ConnectFourWeb, :controller
  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    live_render(conn, GameLive)
  end
end
