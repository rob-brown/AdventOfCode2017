defmodule AdventOfCode.Day3A do
  
  def distance(input) do
    AdventOfCode.Spiral.index_stream 
    |> Enum.at(input - 1)
    |> (fn {x, y} -> abs(x) + abs(y) end).()
  end

  def solve, do: distance(325489)

  def test do
    0 = distance(1)
    3 = distance(12)
    2 = distance(23)
    31 = distance(1024)
    IO.puts "Test Passed"
  end
end
