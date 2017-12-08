defmodule AdventOfCode.Day7B do

  def weight_offset(input) do
    all_nodes = input
    |> Stream.map(&String.split/1)
    |> Stream.reject(&Enum.empty?/1)
    |> Stream.map(&parse_line/1)
    |> Stream.map(& {&1.name, &1})
    |> Map.new
    child_names = all_nodes |> Enum.flat_map(fn {_, node} -> node.children end)
    all_nodes
    |> Map.drop(child_names)
    |> Stream.reject(fn {_, node} -> Enum.empty? node.children end)
    |> Enum.at(0)
    |> elem(1)
    |> check_balance(all_nodes, 0)
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
    60 = input |> String.split("\n") |> weight_offset
    IO.puts "Test Passed"
  end

  def solve do
    "day_7_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> weight_offset
  end

  defp parse_line([name, weight, _ | children]) do
    %{
      name: name,
      weight: weight |> String.trim_leading("(") |> String.trim_trailing(")") |> String.to_integer,
      children: children |> Enum.map(& String.trim(&1, ","))
    }
  end
  defp parse_line([name, weight]) do
    %{
      name: name,
      weight: weight |> String.trim_leading("(") |> String.trim_trailing(")") |> String.to_integer,
      children: []
    }
  end

  # TODO: Convert the list of nodes into a real tree.

  defp check_balance(root, others, expected_weight) do
    if balanced?(root, others) do
      root.children 
      |> Stream.map(& Map.get others, &1) 
      |> Stream.map(& weight &1, others)
      |> Enum.sum
      |> (& expected_weight - &1).()
    else
      root.children
      |> Stream.map(& Map.get others, &1) 
      |> Stream.map(& {weight(&1, others), &1})
      |> Enum.group_by(fn {w, _} -> w end, fn {_, n} -> n end)
      |> Enum.sort_by(fn {_, nodes} -> Enum.count(nodes) end)
      |> case do
        [{_, [unbalanced]}, {balanced_weight, _}] ->
          check_balance(unbalanced, others, balanced_weight)
        _ ->
          :ok
      end
    end
  end

  defp balanced?(%{children: []}, _), do: true
  defp balanced?(node, others) do
    node.children
    |> Stream.map(& Map.get others, &1)
    |> Stream.map(& weight &1, others)
    |> Enum.uniq
    |> (& Enum.count(&1) == 1).()
  end

  defp weight(%{weight: weight, children: []}, _), do: weight
  defp weight(%{weight: weight, children: children}, others) do
    children 
    |> Stream.map(& Map.get others, &1)
    |> Stream.map(& weight &1, others)
    |> Enum.sum 
    |> Kernel.+(weight)
  end
end

