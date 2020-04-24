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
    DotSquare.add_player(@game_id, :A, "test player")
    DotSquare.add_player(@game_id, :B, "test player")
    {a, state} = DotSquare.add_vertex(@game_id, 1, 2)
    assert a == :ok
    assert state.vertices == [%Vertex{pair: {1, 2}, player: :A}]

    {a, _b} = DotSquare.add_vertex(@game_id, 1, 2)
    assert a == :ok
    assert state.vertices == [%Vertex{pair: {1, 2}, player: :A}]

  end

  test "add player test" do
    state = DotSquare.add_player(@game_id, :A, "test player")
    assert state.players == %{A: "test player", B: nil}
  end
end
