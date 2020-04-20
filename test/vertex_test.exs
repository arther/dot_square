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
end
