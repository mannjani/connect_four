defmodule ConnectFour.Player do
  alias ConnectFour.Player
  @enforce_keys [:name, :code, :color]
  defstruct [:name, :code, :color]

  def random_play(board) do
    :timer.sleep(1000)

    board
    |> Map.filter(fn {_, value} -> value == :empty end)
    |> Map.keys()
    |> Enum.random()
    |> Map.get(:col)
  end

  def new(name, color, israndom) do
    code =
      case israndom do
        true -> &random_play/1
        _ -> nil
      end

    {:ok, %Player{name: name, code: code, color: color}}
  end
end
