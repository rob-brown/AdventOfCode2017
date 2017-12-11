defmodule AdventOfCode.Day10A do

  def hash(list, lengths) do
    [first, second | _] = shuffle(list, lengths, 0, 0)
    first * second
  end

  defp shuffle(list, [], _, _), do: list
  defp shuffle(list, [stride | rest], index, skip) do
    list
    |> shift(index)
    |> twist(stride)
    |> shift(-index)
    |> shuffle(rest, rem(index + stride + skip, length(list)), skip + 1)
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
    12 = hash(Enum.to_list(0..4), [3, 4, 1, 5])
    IO.puts "Test Passed"
  end

  def solve do
    hash Enum.to_list(0..255), [31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33]
  end
end
