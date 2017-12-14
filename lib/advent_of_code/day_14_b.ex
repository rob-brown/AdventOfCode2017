defmodule AdventOfCode.Day14B do
  require Bitwise

  def free_regions(input) do
    0..127
    |> Stream.map(&"#{input}-#{&1}")
    |> Stream.map(&hash/1)
    |> build_grid
    |> count_regions
  end

  defp count_regions(grid) do
    (for x <- 0..127, y <- 0..127, do: {x, y})
    |> Stream.with_index(2)
    |> Enum.reduce(grid, fn {{x, y}, n}, acc -> label_region acc, x, y, n end)
    |> Map.values
    |> Stream.reject(& &1 == 0)
    |> MapSet.new
    |> Enum.count
  end

  defp label_region(grid, x, y, n) do
    if Map.get(grid, {x, y}) == 1 do
      grid
      |> Map.put({x, y}, n)
      |> label_region(x + 1, y, n)
      |> label_region(x - 1, y, n)
      |> label_region(x, y + 1, n)
      |> label_region(x, y - 1, n)
    else
      grid
    end
  end

  defp build_grid(hashes) do
    hashes
    |> Stream.with_index
    |> Enum.flat_map(&build_row/1)
    |> Map.new
  end

  defp build_row({row, y}) do
    (for <<b::1 <- row>>, do: b) 
    |> Stream.with_index 
    |> Enum.map(fn {value, x} -> {{x, y}, value} end)
  end

  defp hash(string) when is_binary(string) do
    string |> String.to_charlist |> hash
  end
  defp hash(list) when is_list(list) do
    string_64 = (for _ <- 1..64, do: list ++ [17, 31, 73, 47, 23]) |> List.flatten
    0..255 
    |> Enum.to_list 
    |> shuffle(string_64, 0, 0) 
    |> dense_hash()
    |> Stream.map(&<<&1>>) 
    |> Enum.into(<<>>) 
  end

  defp shuffle(list, [], _, _), do: list
  defp shuffle(list, [stride | rest], index, skip) do
    list
    |> shift(index)
    |> twist(stride)
    |> shift(-index)
    |> shuffle(rest, rem(index + stride + skip, length(list)), skip + 1)
  end

  defp dense_hash(bytes) do
    bytes 
    |> Stream.chunk_every(16) 
    |> Enum.map(fn x -> Enum.reduce(x, 0, &Bitwise.bxor/2) end)
  end

  defp shift(list, 0), do: list
  defp shift(list, offset) when offset < 0 do
    shift list, length(list) + offset
  end
  defp shift(list, offset) do
    {head, tail} = Enum.split(list, offset)
    tail ++ head
  end

  defp twist(list, stride) do
    {chunk, tail} = Enum.split(list, stride)
    Enum.reverse chunk, tail
  end

  def test do
    1242 = free_regions "flqrgnkx"
    IO.puts "Test Passed"
  end

  def solve do
    free_regions "vbqugkhl"
  end
end

