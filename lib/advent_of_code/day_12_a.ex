defmodule AdventOfCode.Day12A do

  def root_size(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(& String.split(&1, " "))
    |> Enum.reduce(%{}, &parse/2)
    |> group(["0"], MapSet.new)
    |> Enum.count
  end

  defp parse([program, "<->" | rest], map) do
    rest 
    |> Enum.map(& String.trim &1, ",") 
    |> Enum.into(MapSet.new) 
    |> (& Map.put map, program, &1).()
  end

  defp group(_, [], seen), do: seen
  defp group(map, [head | rest], seen) do
    if MapSet.member? seen, head do
      group map, rest, seen
    else
      map
      |> Map.get(head)
      |> Enum.to_list
      |> (& rest ++ &1).()
      |> (& group map, &1, MapSet.put(seen, head)).()
    end
  end
  
  def test do
    input = """
    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5
    """
    6 = input |> String.split("\n") |> root_size 
  end

  def solve do
    "day_12_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> root_size
  end
end
