defmodule ConnectFourWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    cond do
      current_user = user_id && ConnectFour.Repo.get(ConnectFour.Repo.User, user_id) ->
        conn
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)

      true ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)
    end
  end
end
