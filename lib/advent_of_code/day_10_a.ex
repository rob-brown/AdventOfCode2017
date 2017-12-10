defmodule AdventOfCode.Day10A do

  def hash(list, lengths) do
    [first, second | _] = shuffle(list, lengths, 0, 0)
    first * second
  end

  defp shuffle(list, [], _, _), do: list
  defp shuffle(list, [stride | rest], index, skip) do
    with length = Enum.count(list),
      new_index = rem(index + stride + skip, length),
      map = list |> Stream.with_index |> Stream.map(fn {x, y} -> {y, x} end) |> Map.new
    do
      list ++ list 
      |> Enum.slice(index..(index + stride - 1)) 
      |> Enum.reverse 
      |> Stream.with_index(index) 
      |> Stream.map(fn {x, n} -> {x, rem(n, length)} end)
      |> Enum.reduce(map, fn {x, n}, acc -> Map.put(acc, n, x) end) 
      |> Enum.sort_by(&elem &1, 0) 
      |> Enum.map(&elem &1, 1)
      |> shuffle(rest, new_index, skip + 1)
    end
  end

  def test do
    12 = hash(Enum.to_list(0..4), [3, 4, 1, 5])
    IO.puts "Test Passed"
  end

  def solve do
    hash Enum.to_list(0..255), [31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33]
  end
end
