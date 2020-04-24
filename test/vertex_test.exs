defmodule DotSquare.VertexTest do
  use ExUnit.Case
  doctest DotSquare
  alias DotSquare.Vertex

  def construct_vertex(pairs) do
    Enum.map(pairs, fn(pair) -> %Vertex{pair: pair} end)
  end

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
    assert Vertex.border({21, 22}, 5, :row) == :bottom
    assert Vertex.border({2, 3}, 5, :row) == :top

    assert Vertex.border({5, 10}, 5, :col) == :right
    assert Vertex.border({6, 11}, 5, :col) == :left

    assert Vertex.border({6, 7}, 5, :row) == :none
    assert Vertex.border({12, 17}, 5, :col) == :none
  end

  test "get score test" do
    vertices = construct_vertex([{1, 6}, {2, 7}, {6, 7}])
    assert Vertex.get_score(vertices, {1, 2}, 5) == {1, [[{1, 6}, {2, 7}, {6, 7}]]}

    vertices = construct_vertex([{4, 9}, {5, 10}, {9, 10}])
    assert Vertex.get_score(vertices, {4, 5}, 5) == {1, [[{4, 9}, {5, 10}, {9, 10}]]}

    vertices = construct_vertex([{4, 5}, {4, 9}, {5, 10}, {9, 14}, {10, 15}, {14, 15}])
    assert Vertex.get_score(vertices, {9, 10}, 5) == {2, [[{4, 5}, {4, 9}, {5, 10}], [{9, 14}, {10, 15}, {14, 15}]]}

    vertices = construct_vertex([{4, 5}, {4, 9}, {5, 10}, {9, 14}, {10, 15}])
    assert Vertex.get_score(vertices, {9, 10}, 5) == {1, [[{4, 5}, {4, 9}, {5, 10}], [{9, 14}, {10, 15}, {14, 15}]]}

    vertices = construct_vertex([{7,8}, {7, 12}, {8, 13}, {12, 17}, {17,18}, {13, 18}])
    assert Vertex.get_score(vertices, {12,13}, 5) == {2, [[{7, 8}, {7, 12}, {8, 13}], [{12, 17}, {13, 18}, {17, 18}]]}

    vertices = construct_vertex([{7,8}, {7, 12}, {8, 13}, {12, 17}, {17,18}, {13, 18}])
    assert Vertex.get_score(vertices, {13, 14}, 5) == {0, [[{8, 9}, {8, 13}, {9, 14}], [{13, 18}, {14, 19}, {18, 19}]]}
  end
end
