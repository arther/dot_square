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

  def add_player(game_id, player_id, name) when is_atom(game_id) do
    Agent.update(game_id, fn(state) -> State.set_player(state, player_id, name) end)
    get_state(game_id)
  end

  def add_player(game_id, player_id, name) when is_binary(game_id) do
    add_player(String.to_atom(game_id), player_id, name)
  end

  def add_vertex(game_id, start_point, end_point) do
    game_id = String.to_atom(game_id)
    state = get_state(game_id)
    add_vertex_internal(game_id, start_point, end_point, State.has_enough_players(state))
  end

  defp add_vertex_internal(_, _, _, false) do
    {:error, "Not enough players to start"}
  end

  defp add_vertex_internal(game_id, start_point, end_point, true) do
    Agent.update(game_id, fn(state) -> handle_add_vertex(state, State.add_vertex(state, start_point, end_point)) end)
    {:ok, get_state(game_id)}
  end

  defp handle_add_vertex(_previous_state, {:ok, state}) do
    state
  end

  defp handle_add_vertex(previous_state, {:error, _}) do
    previous_state
  end

  def kill(game_id) when is_atom(game_id) do
    Agent.stop(game_id, :shutdown)
  end

  def kill(game_id) when is_binary(game_id) do
    kill(String.to_atom(game_id))
  end
end
