defmodule DotSquare.StateTest do
  use ExUnit.Case
  doctest DotSquare
  alias DotSquare.State
  alias DotSquare.Vertex

  test "check if we have enough players to start" do
    state = State.new(5)
    assert State.has_enough_players(state) == false
    state = State.set_player(state, :A, "Player 1")
    state = State.set_player(state, :B, "Player 2")
    assert State.has_enough_players(state) == true
  end

  test "add_vertex test" do
    state = State.new(5)
    {:ok, state} = State.add_vertex(state, 1, 2)
    assert state.current_turn == :B
    assert state.vertices == [%Vertex{pair: {1, 2}, player: :A}]

    {:ok, state} = State.add_vertex(state, 2, 7)
    {:ok, state} = State.add_vertex(state, 6, 7)
    assert state.current_turn == :B

    {:ok, state} = State.add_vertex(state, 1, 6)
    assert state.current_turn == :B
    assert state.points == %{A: 0, B: 1}
  end

  test "add_vertex should throw error test" do
    state = State.new(5)
    {:ok, state} = State.add_vertex(state, 1, 2)
    assert state.vertices == [%Vertex{pair: {1, 2}, player: :A}]

    {:error, msg} = State.add_vertex(state, 1, 2)
    assert state.current_turn == :B
    assert msg == "Invalid vertex pair"
  end
end
