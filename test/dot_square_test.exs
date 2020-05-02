defmodule DotSquareTest do
  use ExUnit.Case
  doctest DotSquare
  alias DotSquare.Vertex

  @game_id "test"

  setup do
    DotSquare.start(@game_id, 5)
    on_exit(fn -> DotSquare.kill(@game_id) end)
  end

  test "add vertex error test" do
    {a, _b} = DotSquare.add_vertex(@game_id, 1, 2)
    assert a == :error
  end

  test "add vertex test" do
    DotSquare.add_player(@game_id, "test player")
    DotSquare.add_player(@game_id, "test player")
    {a, state} = DotSquare.add_vertex(@game_id, 1, 2)
    assert a == :ok
    assert state.vertices == [%Vertex{pair: {1, 2}, player: :A}]

    {a, _b} = DotSquare.add_vertex(@game_id, 1, 2)
    assert a == :ok
    assert state.vertices == [%Vertex{pair: {1, 2}, player: :A}]

  end

  test "add player test" do
    {:ok, state} = DotSquare.add_player(@game_id, "test player 1")
    assert state.players == %{A: "test player 1", B: nil}
    {:ok, state} = DotSquare.add_player(@game_id, "test player 2")
    assert state.players == %{A: "test player 1", B: "test player 2"}
    {:error, state} = DotSquare.add_player(@game_id, "test player 2")
    assert state.players == %{A: "test player 1", B: "test player 2"}
  end

  test "remove player test" do
    {:ok, state} = DotSquare.add_player(@game_id, "test player 1")
    assert state.players == %{A: "test player 1", B: nil}

    {:ok, state} = DotSquare.add_player(@game_id, "test player 2")
    assert state.players == %{A: "test player 1", B: "test player 2"}

    {:ok, state} = DotSquare.remove_player(@game_id, :B)
    assert state.players == %{A: "test player 1", B: nil}

    {:ok, state} = DotSquare.remove_player(@game_id, :A)
    assert state.players == %{A: nil, B: nil}

    {:ok, state} = DotSquare.add_player(@game_id, "test player 2")
    assert state.players == %{A: "test player 2", B: nil}

    {:ok, state} = DotSquare.add_player(@game_id, "test player 1")
    assert state.players == %{A: "test player 2", B: "test player 1"}
  end
end
