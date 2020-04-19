defmodule DotSquare.State do
  alias DotSquare.Vertex

  defstruct vertices: [], players: %{A: nil, B: nil}, current_turn: nil, size: 5

  def new(size) do
    %__MODULE__{size: size}
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
  def add_vertex(%__MODULE__{} = state, start_point, end_point, player) do
    pair = {start_point, end_point}
    vertices =  state.vertices
    if(Vertex.is_already_marked?(pair)) do
      {:error, "Already Marked"}
    else
      state = %__MODULE__{state | vertices: vertices ++ new_vertex}
      {:ok, state}
    end
  end
end
