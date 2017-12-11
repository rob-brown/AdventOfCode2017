defmodule AdventOfCode.Day10B do
  require Bitwise

  def hash(string) when is_binary(string) do
    string |> String.to_charlist |> hash
  end
  def hash(list) when is_list(list) do
    string_64 = (for _ <- 1..64, do: list ++ [17, 31, 73, 47, 23]) |> List.flatten
    0..255 
    |> Enum.to_list 
    |> shuffle(string_64, 0, 0) 
    |> dense_hash()
    |> Stream.map(&<<&1>>) 
    |> Enum.into("") 
    |> Base.encode16 
    |> String.downcase
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
    bytes |> Stream.chunk_every(16) |> Enum.map(fn x -> Enum.reduce(x, 0, &Bitwise.bxor/2) end)
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
    "a2582a3a0e66e6e86e3812dcb672a272" = hash ""
    "33efeb34ea91902bb2f59c9920caa6cd" = hash "AoC 2017"
    "3efbe78a8d82f29979031a4aa0b16a9d" = hash "1,2,3"
    "63960835bcdc130f0b66d7ff4f6a5a8e" = hash "1,2,4"
    IO.puts "Test Passed"
  end

  def solve do
    hash "31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33"
  end
end

