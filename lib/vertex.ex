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

  defp is_valid_pair?(0, _, 1), do: false

  defp is_valid_pair?(_, 0, 1), do: false

  defp is_valid_pair?(0, 0, 5), do: true

  defp is_valid_pair?(x, x, 5), do: true

  defp is_valid_pair?(_, _, 1), do: true

  def add_vertix(vertices, {a, b} = pair, player, size) do
    if(is_valid_pair?(rem(a, size), rem(b, size), b - a)) do
      {:ok, vertices ++ [%__MODULE__{pair: pair, player: player}]}
    else
      {:error, vertices}
    end
  end

  def square_formed?(vertices, start_point, end_point, size) do

  end

end
