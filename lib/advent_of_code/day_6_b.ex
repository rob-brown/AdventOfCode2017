defmodule AdventOfCode.Day6B do

  def cycle_size(input) do
    input
    |> Stream.with_index
    |> Stream.map(fn {x, y} -> {y, x} end)
    |> Map.new
    |> cycle_size(0, Map.new)
  end

  defp cycle_size(banks, n, history) do
    {index, max} = banks |> Enum.max_by(fn {n, x} -> {x, -n} end)
    new_banks = 
      banks 
      |> Map.put(index, 0)
      |> spread(max, rem(index + 1, Enum.count(banks))) 

    case Map.get(history, new_banks) do
      nil ->
        new_history = Map.put(history, banks, n)
        cycle_size(new_banks, n + 1, new_history)
      index ->
        n - index + 1
    end
  end

  defp spread(banks, 0, _), do: banks
  defp spread(banks, amount, index) do
    banks
    |> Map.update!(index, (& &1 + 1))
    |> spread(amount - 1, rem(index + 1, Enum.count(banks)))
  end

  def test do
    4 = cycle_size([0, 2, 7, 0])
    IO.puts "Test Passed"
  end

  def solve do
    cycle_size([14, 0, 15, 12, 11, 11, 3, 5, 1, 6, 8, 4, 9, 1, 8, 4])
  end
end
