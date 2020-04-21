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

  defp valid_pair?(0, _, 1), do: false

  defp valid_pair?(_, 0, 1), do: false

  defp valid_pair?(0, 0, 5), do: true

  defp valid_pair?(x, x, 5), do: true

  defp valid_pair?(_, _, 1), do: true

  defp valid_pair?({a, b} = _pair, size) do
    valid_pair?(rem(a, size), rem(b, size), b - a)
  end

  def add_vertix(vertices, pair, player, size) do
    if(valid_pair?(pair, size)) do
      {:ok, vertices ++ [%__MODULE__{pair: pair, player: player}]}
    else
      {:error, vertices}
    end
  end

  defp row?({a, b} = _pair) do
    b - a == 1
  end

  defp col?({a, b} = _pair, size) do
    b - a == size
  end

  def border({a, _b} = _pair, size, false = _row?) do
    case (rem(a, size)) do
      0 ->  :right
      1 -> :left
      _ -> :none
    end
  end

  def border({a, b} = _pair, size, true = _row?) do
    last_row = size * (size - 1)
    case (a) do
      x  when x < size -> :top
      x when x > last_row -> :bottom
      _ -> :none
    end
  end

  def square_formed?(vertices, pair, size) do
    row?(pair)
  end

end
