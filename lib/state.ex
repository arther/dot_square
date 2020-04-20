defmodule DotSquare.State do
  alias DotSquare.Vertex

  defstruct vertices: [], players: %{A: nil, B: nil}, current_turn: A, size: 5

  def new(size) do
    %__MODULE__{size: size}
  end


  def set_player(state, A, player) do
    %__MODULE__{state | players:  %{state.players | A: player }}
  end

  def set_player(state, B, player) do
    %__MODULE__{state | players:  %{state.players | B: player }}
  end

  def has_enough_players(%__MODULE__{players: %{A: nil, B: _}}) do
    false
  end

  def has_enough_players(%__MODULE__{players: %{A: _, B: nil}}) do
    false
  end

  def has_enough_players(%__MODULE__{players: %{A: _, B: _}}) do
    true
  end

  defp switch_turn_internal(state, A) do
    %__MODULE__{state | current_turn: B}
  end

  defp switch_turn_internal(state, B) do
    %__MODULE__{state | current_turn: A}
  end

  def switch_turn(state) do
    switch_turn_internal(state, state.current_turn)
  end

  def add_vertex(%__MODULE__{} = state, start_point, end_point) do
    pair = {start_point, end_point}
    vertices =  state.vertices
    if(Vertex.is_already_marked?(pair, vertices, false)) do
      {:error, "Vertex already exists"}
    else
      state = %__MODULE__{state | vertices: Vertex.add_vertix(vertices, pair, state.current_turn)}
      state = switch_turn(state)
      {:ok, state}
    end
  end
end
