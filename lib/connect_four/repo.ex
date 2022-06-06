defmodule ConnectFour.Repo do
  use Ecto.Repo,
    otp_app: :connect_four,
    adapter: Ecto.Adapters.SQLite3
end
