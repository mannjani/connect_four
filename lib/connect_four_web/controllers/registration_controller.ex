defmodule ConnectFourWeb.RegistrationController do
  use ConnectFourWeb, :controller

  def new(conn, _) do
    render(conn, :new, changeset: ConnectFour.Repo.User.change_user(), action: "/register")
  end

  def create(conn, %{"user" => user}) do
    case ConnectFour.Repo.User.register(user) do
      {:ok, _user} ->
        redirect(conn, changeset: ConnectFour.Repo.User.change_user(), to: "/login")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset, action: "/register")
    end
  end
end
