defmodule ConnectFour.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :black, references(:users)
      add :red, references(:users)
      add :moves, :array
      add :winner, :string
    end
  end
end
