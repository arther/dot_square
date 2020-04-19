defmodule DotSquareTest do
  use ExUnit.Case
  doctest DotSquare

  test "greets the world" do
    assert DotSquare.hello() == :world
  end
end
