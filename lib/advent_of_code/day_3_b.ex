defmodule AdventOfCode.Day3B do
  alias AdventOfCode.Spiral

  def value(input) do
    Spiral.index_stream
    |> Stream.drop(1)
    |> Stream.scan({%{{0, 0} => 1}, 1}, &process/2)
    |> Stream.drop_while(fn {_, n} -> n <= input end)
    |> Enum.at(0)
    |> elem(1)
  end

  def solve, do: value(325489)

  def test do
    2 = value(1)
    4 = value(2)
    4 = value(3)
    5 = value(4)
    10 = value(5)
    54 = value(50)
    122 = value(100)
    IO.puts "Test Passed"
  end

  defp process(index, {map, _}) do
    index
    |> Spiral.neighbors
    |> Stream.map(& Map.get map, &1, 0)
    |> Enum.sum
    |> (& {Map.put(map, index, &1), &1}).()
  end
end
