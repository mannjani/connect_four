defmodule ConnectFourWeb.SessionController do
  use ConnectFourWeb, :controller

  def new(conn, _params) do
    render(conn, :new, changeset: ConnectFour.Repo.User.change_user(), action: "/login")
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case ConnectFour.Repo.User.authenticate(username, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You have successfully signed in!")
        |> redirect(to: "/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid Username or Password")
        |> render(:new, changeset: ConnectFour.Repo.User.change_user(), action: "/login")
    end
  end
end
