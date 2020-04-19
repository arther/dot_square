defmodule DotSquare do
  use Agent
  alias DotSquare.State

  def start(game_id, size) do
    game_id = game_id |> String.to_atom()
    Agent.start(fn -> State.new(size) end, name: game_id)
    {:ok, game_id, get_state(game_id)}
  end

  def get_state(game_id) when is_atom(game_id) do
    Agent.get(game_id, fn(x) -> x end)
  end

  def get_state(game_id) when is_binary(game_id) do
    get_state(String.to_atom(game_id))
  end

  def mark_vertex(game_id, start_point, end_point) do
    state = get_state(String.to_atom(game_id))
    if(!State.has_enough_players(state)) do
      {:error, "Not enough players"}
    end

  end

end
