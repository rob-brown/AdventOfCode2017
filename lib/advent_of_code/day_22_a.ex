defmodule AdventOfCode.Day22A do

  def infect(input, iterations) do
    input 
    |> Stream.map(&String.trim/1) 
    |> Stream.reject(& &1 == "") 
    |> parse_grid
    |> run(iterations)
  end

  defp parse_grid(input) do
    middle = input |> Enum.at(0) |> String.length |> (& div(&1, 2)).()
    input
    |> Stream.with_index(-middle)
    |> Stream.flat_map(fn {row, y} -> 
      row 
      |> String.codepoints 
      |> Stream.with_index(-middle) 
      |> Stream.map(fn {value, x} -> {{x, y}, value} end) end)
    |> Map.new
  end
  
  defp run(grid, position \\ {0, 0}, direction \\ :up, iterations, infections \\ 0)
  defp run(_, _, _, 0, infections), do: infections
  defp run(grid, {x, y}, direction, iterations, infections) do
    case Map.get(grid, {x, y}, ".") do
      "#" ->
        new_direction = turn_right direction
        grid
        |> Map.put({x, y}, ".")
        |> run(move({x, y}, new_direction), new_direction, iterations - 1, infections)
      "." ->
        new_direction = turn_left direction
        grid
        |> Map.put({x, y}, "#")
        |> run(move({x, y}, new_direction), new_direction, iterations - 1, infections + 1)
    end
  end

  defp move({x, y}, :up),    do: {x, y - 1}
  defp move({x, y}, :right), do: {x + 1, y}
  defp move({x, y}, :down),  do: {x, y + 1}
  defp move({x, y}, :left),  do: {x - 1, y}

  defp turn_right(:up),    do: :right
  defp turn_right(:right), do: :down
  defp turn_right(:down),  do: :left
  defp turn_right(:left),  do: :up
  
  defp turn_left(:up),    do: :left
  defp turn_left(:right), do: :up
  defp turn_left(:down),  do: :right
  defp turn_left(:left),  do: :down

  defp print(grid) do
    min_x = grid |> Stream.map(fn {{x, _}, _} -> x end) |> Enum.min
    max_x = grid |> Stream.map(fn {{x, _}, _} -> x end) |> Enum.max
    min_y = grid |> Stream.map(fn {{_, y}, _} -> y end) |> Enum.min
    max_y = grid |> Stream.map(fn {{_, y}, _} -> y end) |> Enum.max
    for y <- min_y..max_y, into: "" do
      for x <- min_x..max_x, into: "" do
        Map.get(grid, {x, y}, ".")
      end
      |> (& &1 <> "\n").()
    end
    |> IO.puts
    grid
  end

  def test do
    input = """
    ..#
    #..
    ...
    """
    5 = input |> String.split("\n") |> infect(7)
    41 = input |> String.split("\n") |> infect(70)
    5587 = input |> String.split("\n") |> infect(10_000)
    IO.puts "Test Passed"
  end

  def solve do
    "day_22_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split("\n")
    |> infect(10_000)
  end
end
