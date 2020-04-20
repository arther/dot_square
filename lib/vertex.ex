defmodule DotSquare.Vertex do

  defstruct pair: {}, player: nil;

  def is_already_marked?(_, _, true) do
    true
  end

  def is_already_marked?(_, [], false) do
    false
  end

  def is_already_marked?(pair, vertices, false) do
    [head | tail] = vertices
    is_already_marked?(pair, tail, head.pair == pair)
  end

  def add_vertix(vertices, pair, player) do
    vertices ++ [%__MODULE__{pair: pair, player: player}]
  end

end
