defmodule ConnectFourWeb.PageController do
  use ConnectFourWeb, :controller
  plug ConnectFourWeb.Plugs.AuthenticateUser when action in [:index]

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
