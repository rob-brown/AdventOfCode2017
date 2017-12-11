defmodule AdventOfCode.Day11B do

  # https://www.redblobgames.com/grids/hexagons/#distances

  def max_distance(input) do
    input
    |> String.split(",")
    |> Stream.map(&String.trim/1)
    |> Stream.scan({0, 0, 0}, &move/2) 
    |> Stream.map(&distance/1)
    |> Enum.max
  end

  defp move("n",  {x, y, z}), do: {x,     y + 1, z - 1}
  defp move("ne", {x, y, z}), do: {x + 1, y,     z - 1}
  defp move("nw", {x, y, z}), do: {x - 1, y + 1, z}
  defp move("s",  {x, y, z}), do: {x,     y - 1, z + 1}
  defp move("se", {x, y, z}), do: {x + 1, y - 1, z}
  defp move("sw", {x, y, z}), do: {x - 1, y,     z + 1}

  defp distance({x1, y1, z1}, {x2, y2, z2} \\ {0, 0, 0}) do
    div(abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2), 2)
  end

  def test do
    3 = max_distance "ne,ne,ne"
    2 = max_distance "ne,ne,sw,sw"
    2 = max_distance "ne,ne,s,s"
    3 = max_distance "se,sw,se,sw,sw"
    IO.puts "Test Passed"
  end

  def solve do
    "day_11_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> max_distance
  end
end

