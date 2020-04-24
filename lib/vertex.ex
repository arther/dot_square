defmodule DotSquare.Vertex do
  defstruct pair: {}, player: nil

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

  defp row_or_col({a, b} = _pair) when b - a == 1, do: :row

  defp row_or_col(_pair), do: :col

  def border({a, _b} = _pair, size, :col) do
    case rem(a, size) do
      0 -> :right
      1 -> :left
      _ -> :none
    end
  end

  def border({a, _b} = _pair, size, :row) do
    last_row = size * (size - 1)

    case a do
      x when x < size -> :top
      x when x > last_row -> :bottom
      _ -> :none
    end
  end

  # a--b
  # |  |
  # c--d
  # |  |
  # e--f
  defp get_box_pair(:row, :none, {c, d} = _pair, size) do
    a = c - size
    b = d - size
    e = c + size
    f = d + size
    [[{a, b}, {a, c}, {b, d}], [{c, e}, {d, f}, {e, f}]]
  end

  # c--d
  # |  |
  # e--f
  defp get_box_pair(:row, :top, {c, d} = _pair, size) do
    e = c + size
    f = d + size
    [[{c, e}, {d, f}, {e, f}]]
  end

  # a--b
  # |  |
  # c--d
  defp get_box_pair(:row, :bottom, {c, d} = _pair, size) do
    a = c - size
    b = d - size
    [[{a, b}, {a, c}, {b, d}]]
  end

  # a--c--e
  # |  |  |
  # b--d--f
  defp get_box_pair(:col, :none, {c, d} = _pair, _size) do
    a = c - 1
    b = d - 1
    e = c + 1
    f = d + 1
    [[{a, b}, {a, c}, {b, d}], [{c, e}, {d, f}, {e, f}]]
  end

  # a--c
  # |  |
  # b--d
  defp get_box_pair(:col, :right, {c, d} = _pair, _size) do
    a = c - 1
    b = d - 1
    [[{a, b}, {a, c}, {b, d}]]
  end

  # c--e
  # |  |
  # d--f
  defp get_box_pair(:col, :left, {c, d} = _pair, _size) do
    e = c + 1
    f = d + 1
    [[{c, e}, {d, f}, {e, f}]]
  end

  defp score([[x, x, x]]) when x == true, do: 1

  defp score([[_, _, _]]), do: 0

  defp score([[x, x, x], [x, x, x]]) when x == true, do: 2

  defp score([[x, x, x], [_, _, _]]) when x == true, do: 1

  defp score([[_, _, _], [y, y, y]]) when y == true, do: 1

  defp score([[_, _, _], [_, _, _]]), do: 0

  def get_score(vertices, pair, size) do
    axis = row_or_col(pair)
    border = border(pair, size, axis)
    sides = get_box_pair(axis, border, pair, size)

    score =
      sides
      |> Enum.map(fn pairs ->
        Enum.map(pairs, fn pair -> is_already_marked?(pair, vertices, false) end)
      end)
      |> score
    {score, sides}
  end
end
