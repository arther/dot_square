defmodule DotSquare do
  use Agent
  alias DotSquare.State

  def start(game_id, size) when is_binary(game_id) do
    game_id = game_id |> String.to_atom()
    start(game_id, size)
  end

  def start(game_id, size) when is_atom(game_id) do
    Agent.start(fn -> State.new(size) end, name: game_id)
    {:ok, game_id, get_state(game_id)}
  end

  def get_state(game_id) when is_atom(game_id) do
    Agent.get(game_id, fn(x) -> x end)
  end

  def get_state(game_id) when is_binary(game_id) do
    get_state(String.to_atom(game_id))
  end

  defp add_player_internal(game_id, _name, true) do
    {:error, get_state(game_id)}
  end

  defp add_player_internal(game_id, name, false) do
    Agent.update(game_id, fn(state) -> State.set_player(state, name) end)
    {:ok, get_state(game_id)}
  end
  def add_player(game_id, name) when is_atom(game_id) do
    add_player_internal(game_id, name, State.has_enough_players(get_state(game_id)))
  end

  def add_player(game_id, name) when is_binary(game_id) do
    add_player(String.to_atom(game_id), name)
  end

  def remove_player(game_id, player_id) when is_atom(game_id) do
    Agent.update(game_id, fn(state) -> State.unset_player(state, player_id) end)
    {:ok, get_state(game_id)}
  end

  def remove_player(game_id, player_id) when is_binary(game_id) do
    remove_player(String.to_atom(game_id), player_id)
  end

  def add_vertex(game_id, start_point, end_point) when is_atom(game_id) do
    state = get_state(game_id)
    add_vertex_internal(game_id, start_point, end_point, State.has_enough_players(state))
  end

  def add_vertex(game_id, start_point, end_point) when is_binary(game_id) do
    game_id = String.to_atom(game_id)
    add_vertex(game_id, start_point, end_point)
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

  def is_game_alive?(game_id) when is_atom(game_id) do
    Process.whereis(game_id) != nil
  end

  def is_game_alive?(game_id) when is_binary(game_id) do
    is_game_alive?(String.to_atom(game_id))
  end

  def kill(game_id) when is_atom(game_id) do
    Agent.stop(game_id, :shutdown)
  end

  def kill(game_id) when is_binary(game_id) do
    kill(String.to_atom(game_id))
  end
end
