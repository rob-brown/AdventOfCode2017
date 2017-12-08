defmodule AdventOfCode.Day7A do

  def bottom(input) do
    nodes = input
    |> Stream.map(&String.split/1)
    |> Stream.reject(&Enum.empty?/1)
    |> Stream.map(&parse_line/1)
    |> Stream.reject(& Enum.empty? &1.children)
    |> Stream.map(& {&1.name, &1})
    |> Map.new
    child_names = Enum.flat_map(nodes, (fn {_, node} -> node.children end)) 
    nodes 
    |> Map.drop(child_names)
    |> Enum.at(0)
    |> elem(1)
    |> (& &1.name).()
  end

  def test do
    input = """
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
    """
    "tknk" = input |> String.split("\n") |> bottom
    IO.puts "Test Passed"
  end

  def solve do
    "day_7_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> bottom
  end

  defp parse_line([name, weight, _ | children]) do
    %{
      name: name,
      weight: weight |> String.trim_leading("(") |> String.trim_trailing(")"),
      children: children |> Enum.map(& String.trim(&1, ","))
    }
  end
  defp parse_line([name, weight]) do
    %{
      name: name,
      weight: weight |> String.trim_leading("(") |> String.trim_trailing(")"),
      children: []
    }
  end
end
