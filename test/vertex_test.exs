defmodule DotSquare.VertexTest do
  use ExUnit.Case
  doctest DotSquare
  alias DotSquare.Vertex

  test "add vertix test" do
    vertices = [%Vertex{pair: {1, 2}, player: A}]
    assert Vertex.add_vertix(vertices, {2, 3}, A, 5) == {:ok, [%Vertex{pair: {1, 2}, player: A}, %Vertex{pair: {2, 3}, player: A}]}
    assert Vertex.add_vertix(vertices, {15, 16}, A, 5) == {:error, vertices}
    assert Vertex.add_vertix(vertices, {3, 8}, A, 5) == {:ok, [%Vertex{pair: {1, 2}, player: A}, %Vertex{pair: {3, 8}, player: A}]}
  end

  test "check if the vertex already exists" do
    vertices = [%Vertex{pair: {1, 2}, player: A}, %Vertex{pair: {2, 3}, player: A}]
    assert Vertex.is_already_marked?({1,2}, vertices, false) == true
    assert Vertex.is_already_marked?({2,6}, vertices, false) == false
  end

  test "border find test" do
    assert Vertex.border({21, 22}, 5, true) == :bottom
    assert Vertex.border({2, 3}, 5, true) == :top

    assert Vertex.border({5, 10}, 5, false) == :right
    assert Vertex.border({6, 11}, 5, false) == :left

    assert Vertex.border({6, 7}, 5, true) == :none
    assert Vertex.border({12, 17}, 5, false) == :none
  end
end
