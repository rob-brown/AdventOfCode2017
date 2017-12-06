defmodule AdventOfCode.Day6A do
  
  def redistribute(input) do
    input
    |> Stream.with_index
    |> Stream.map(fn {x, y} -> {y, x} end)
    |> Map.new
    |> redistribute(0, MapSet.new)
  end

  defp redistribute(banks, n, history) do
    {index, max} = banks |> Enum.max_by(fn {n, x} -> {x, -n} end)
    new_banks = 
      banks 
      |> Map.put(index, 0)
      |> spread(max, rem(index + 1, Enum.count(banks))) 

    if MapSet.member?(history, new_banks) do
      n + 1
    else
      new_history = MapSet.put(history, banks)
      redistribute(new_banks, n + 1, new_history)
    end
  end

  defp spread(banks, 0, _), do: banks
  defp spread(banks, amount, index) do
    banks
    |> Map.update!(index, (& &1 + 1))
    |> spread(amount - 1, rem(index + 1, Enum.count(banks)))
  end

  def test do
    5 = redistribute([0, 2, 7, 0])
    IO.puts "Test Passed"
  end

  def solve do
    redistribute([14, 0, 15, 12, 11, 11, 3, 5, 1, 6, 8, 4, 9, 1, 8, 4])
  end
end
