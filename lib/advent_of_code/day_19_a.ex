defmodule AdventOfCode.Day19A do
  
  def traverse(input) do
    input
    |> build_grid
    |> find_start
    |> run
    |> Enum.join
  end

  defp build_grid(lines) do
    lines
    |> Stream.with_index
    |> Enum.flat_map(&process_line/1)
    |> Map.new
  end

  defp process_line({line, y}) do
    line 
    |> String.codepoints 
    |> Stream.with_index 
    |> Stream.reject(fn {c, _} -> c in [" ", "\n"] end) 
    |> Enum.map(fn {c, x} -> {{x, y}, c} end) 
  end

  defp find_start(grid) do
    grid
    |> Stream.filter(fn {{_, y}, c} -> y == 0 and c == "|" end)
    |> Stream.map(fn {{x, y}, _} -> {x, y} end)
    |> Enum.at(0)
    |> (& {grid, &1, :down}).()
  end

  defp run({grid, {x, y}, direction}, result \\ []) do
    case Map.get(grid, {x, y}, " ") do
      " " -> 
        Enum.reverse result
      "+" ->
        {{new_x, new_y}, new_direction} = turn grid, {x, y}, direction
        run {grid, {new_x, new_y}, new_direction}, result
      path when path in ["-", "|"] ->
        run {grid, move({x, y}, direction), direction}, result
      letter -> 
        run {grid, move({x, y}, direction), direction}, [letter | result]
    end
  end

  defp move({x, y}, :down),  do: {x, y + 1}
  defp move({x, y}, :up),    do: {x, y - 1}
  defp move({x, y}, :right), do: {x + 1, y}
  defp move({x, y}, :left),  do: {x - 1, y}

  defp turn(grid, {x, y}, direction) when direction in [:left, :right] do
    [:up, :down] 
    |> Stream.map(& {move({x, y}, &1), &1}) 
    |> Stream.reject(fn {{x, y}, _} -> Map.get(grid, {x, y}, " ") == " " end) 
    |> Enum.at(0)
  end
  defp turn(grid, {x, y}, direction) when direction in [:up, :down] do
    [:left, :right] 
    |> Stream.map(& {move({x, y}, &1), &1}) 
    |> Stream.reject(fn {{x, y}, _} -> Map.get(grid, {x, y}, " ") == " " end) 
    |> Enum.at(0)
  end

  def test do
    input = """
          |          
          |  +--+    
          A  |  C    
      F---|----E|--+ 
          |  |  |  D 
          +B-+  +--+ 
    """
    "ABCDEF" = input |> String.split("\n") |> traverse
    IO.puts "Test Passed"
  end

  def solve do
    "day_19_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split("\n")
    |> traverse
  end
end
