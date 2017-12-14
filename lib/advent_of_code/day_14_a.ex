defmodule AdventOfCode.Day14A do
  require Bitwise

  def free_size(input) do
    0..127
    |> Stream.map(&"#{input}-#{&1}")
    |> Stream.map(&hash/1)
    |> Stream.map(& count_zeroes &1, 0)
    |> Enum.sum
  end

  defp count_zeroes(<<>>, total), do: total
  defp count_zeroes(<<1::1, rest::bitstring>>, total) do
    count_zeroes rest, total + 1
  end
  defp count_zeroes(<<0::1, rest::bitstring>>, total) do
    count_zeroes rest, total
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
    8108 = free_size "flqrgnkx"
    IO.puts "Test Passed"
  end

  def solve do
    free_size "vbqugkhl"
  end
end
