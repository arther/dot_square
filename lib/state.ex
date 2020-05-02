defmodule DotSquare.State do
  alias DotSquare.Vertex

  defstruct vertices: [],
            players: %{A: nil, B: nil},
            current_turn: :A,
            size: 5,
            points: %{A: 0, B: 0},
            game_done: false,
            boxes: %{A: [], B: []}

  def new(size) do
    %__MODULE__{size: size}
  end

  def set_player(%__MODULE__{players: %{A: nil, B: _}} = state, player) do
    %__MODULE__{state | players: %{state.players | A: player}}
  end

  def set_player(%__MODULE__{players: %{A: _, B: nil}} = state, player) do
    %__MODULE__{state | players: %{state.players | B: player}}
  end

  def unset_player(state, :A) do
    %__MODULE__{state | players: %{state.players | A: nil}}
  end

  def unset_player(state, :B) do
    %__MODULE__{state | players: %{state.players | B: nil}}
  end

  defp update_player_points(%__MODULE__{current_turn: :A} = state, score) do
    %__MODULE__{state | points: %{state.points | A: state.points[:A] + score}}
  end

  defp update_player_points(%__MODULE__{current_turn: :B} = state, score) do
    %__MODULE__{state | points: %{state.points | B: state.points[:B] + score}}
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

  defp switch_turn_internal(state, :A) do
    %__MODULE__{state | current_turn: :B}
  end

  defp switch_turn_internal(state, :B) do
    %__MODULE__{state | current_turn: :A}
  end

  def switch_turn(state) do
    switch_turn_internal(state, state.current_turn)
  end

  defp update_boxes(%__MODULE__{current_turn: :B} = state, sides, pair, 1 = _score) do
    box = sides ++ pair
    %{state | boxes: %{state.boxes | B: state.boxes[:B] ++ [box]}}
  end

  defp update_boxes(%__MODULE__{current_turn: :A} = state, sides, pair, 1 = _score) do
    box = sides ++ pair
    %{state | boxes: %{state.boxes | A: state.boxes[:A] ++ [box]}}
  end

  defp update_boxes(state, _sides, _pair, 0 = _score) do
    state
  end

  defp udpate_vertices(state, {:ok, vertices}) do
    %__MODULE__{state | vertices: vertices}
  end

  defp udpate_vertices(state, {:error, _vertices}) do
    state
  end

  defp update_game_status(state) do
    total_vertices = state.size * (state.size - 1) * 2
    %__MODULE__{state | game_done: total_vertices == length(state.vertices)}
  end

  defp update_turn(state, :A) do
    %__MODULE__{state | current_turn: :B}
  end

  defp update_turn(state, :B) do
    %__MODULE__{state | current_turn: :A}
  end

  defp update_turn(state, [{x, _}]) when x == 0 do
    update_turn(state, state.current_turn)
  end

  defp update_turn(state, [{x, _}, {x, _}]) when x == 0 do
    update_turn(state, state.current_turn)
  end

  defp update_turn(state, [{_, _}, {_, _}]), do: state
  defp update_turn(state, [{_, _}]), do: state

  defp handle_score_resp(state, _pair, []) do
    state
  end

  defp handle_score_resp(state, pair, sides_list) do
    [side | rest] = sides_list
    {score, sides} = side
    state = update_player_points(state, score)
    state = update_boxes(state, sides, [pair], score)
    handle_score_resp(state, pair, rest)
  end

  def add_vertex(%__MODULE__{} = state, start_point, end_point) do
    pair = {start_point, end_point}
    vertices = state.vertices

    if(Vertex.is_already_marked?(pair, vertices, false)) do
      {:error, "Invalid vertex pair"}
    else
      vertex_resp = Vertex.add_vertix(vertices, pair, state.current_turn, state.size)
      score_resp = Vertex.get_score(state.vertices, pair, state.size)
      state = udpate_vertices(state, vertex_resp)
      state = update_turn(state, score_resp)
      state = handle_score_resp(state, pair, score_resp)
      state = update_game_status(state)
      {:ok, state}
    end
  end
end
