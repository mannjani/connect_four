defmodule ConnectFour.Repo.Game do
  use Ecto.Schema

  schema "games" do
    belongs_to :black, ConnectFour.Repo.User
    belongs_to :red, ConnectFour.Repo.User
    field :moves, {:array, :integer}
    field :winner, Ecto.Enum, values: [:black, :red, :tie]
  end
end
