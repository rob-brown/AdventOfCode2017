defmodule AdventOfCode.Day24A do

  def build_bridge(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.reject(& &1 == "")
    |> Stream.map(&parse_line/1)
    |> construct 
    |> Stream.map(&Enum.sum/1)
    |> Enum.max
  end

  defp parse_line(line) do
    line |> String.split("/") |> Enum.map(&String.to_integer/1) |> List.to_tuple
  end

  defp construct(parts, built = [previous | _] \\ [0]) do
    parts
    |> Stream.filter(fn {x, y} -> x == previous or y == previous end)
    |> Enum.flat_map(fn 
      item = {^previous, y} ->
        parts |> Enum.reject(& &1 == item) |> construct([y, previous | built])
      item = {x, ^previous} ->
        parts |> Enum.reject(& &1 == item) |> construct([x, previous | built])
    end)
    |> case do
      [] ->
        [built]
      subconstructs ->
        subconstructs
    end
  end

  def test do
    input = """
    0/2
    2/2
    2/3
    3/4
    3/5
    0/1
    10/1
    9/10
    """
    31 = input |> String.split("\n") |> build_bridge
    IO.puts "Test Passed"
  end

  def solve do
    "day_24_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> build_bridge
  end
end
