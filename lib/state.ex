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

  def set_player(state, :A, player) do
    %__MODULE__{state | players: %{state.players | A: player}}
  end

  def set_player(state, :B, player) do
    %__MODULE__{state | players: %{state.players | B: player}}
  end

  defp update_score(points, :A, score) do
    %{points | A: points[:A] + score}
  end

  defp update_score(points, :B, score) do
    %{points | B: points[:B] + score}
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

  defp update_boxes(state, sides, pair, 2, :B) do
    side1 = Enum.at(sides, 0)
    side2 = Enum.at(sides, 1)

    box1 = side1 ++ pair
    box2 = side2 ++ pair
    %{state | boxes: %{state.boxes | B: state.boxes[:B] ++ [box1] ++ [box2]}}
  end

  defp update_boxes(state, sides, pair, 1, :B) do
    side = Enum.at(sides, 0)
    box = side ++ pair
    %{state | boxes: %{state.boxes | B: state.boxes[:B] ++ [box]}}
  end

  defp update_boxes(state, sides, pair, 2, :A) do
    side1 = Enum.at(sides, 0)
    side2 = Enum.at(sides, 1)

    box1 = side1 ++ pair
    box2 = side2 ++ pair
    %{state | boxes: %{state.boxes | A: state.boxes[:A] ++ [box1] ++ [box2]}}
  end

  defp update_boxes(state, sides, pair, 1, :A) do
    side = Enum.at(sides, 0)

    box = side ++ pair
    %{state | boxes: %{state.boxes | A: state.boxes[:A] ++ [box]}}
  end

  defp update_boxes(state, _sides, _pair, 0, _) do
    state
  end

  defp update_state(state, {:ok, vertices}, score) when score == 0 do
    state = %__MODULE__{state | vertices: vertices}
    switch_turn(state)
  end

  defp update_state(state, {:ok, vertices}, score) when score > 0 do
    player = state.current_turn
    points = update_score(state.points, player, score)
    %__MODULE__{state | vertices: vertices, points: points}
  end

  defp update_state(state, {:error, _vertices}, _score) do
    state
  end

  defp update_game_status(state) do
    game_over = state.size * (state.size - 1) * 2
    %__MODULE__{state | game_done: game_over}
  end

  def add_vertex(%__MODULE__{} = state, start_point, end_point) do
    pair = {start_point, end_point}
    vertices = state.vertices

    if(Vertex.is_already_marked?(pair, vertices, false)) do
      {:error, "Invalid vertex pair"}
    else
      vertex_resp = Vertex.add_vertix(vertices, pair, state.current_turn, state.size)
      {score, sides} = Vertex.get_score(state.vertices, pair, state.size)
      state = update_boxes(state, sides, [pair], score, state.current_turn)
      state = update_state(state, vertex_resp, score)
      state = update_game_status(state)
      {:ok, state}
    end
  end
end
