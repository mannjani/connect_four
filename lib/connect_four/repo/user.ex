defmodule ConnectFour.Repo.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ConnectFour.Repo.User

  schema "users" do
    field :username, :string
    field :password, :string
    field :code, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:username)
  end

  def register(params) do
    %User{}
    |> User.changeset(params)
    |> ConnectFour.Repo.insert()
  end

  def authenticate(username, password) do
    user = ConnectFour.Repo.get_by(User, username: username)

    cond do
      user && user.password == password ->
        {:ok, user}

      true ->
        {:error, :unauthorized}
    end
  end

  def change_user(user \\ %User{}) do
    User.changeset(user, %{})
  end
end
