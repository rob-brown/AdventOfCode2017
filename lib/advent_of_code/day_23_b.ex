defmodule AdventOfCode.Day23B do

  def solve do
    0..1000 
    |> Stream.map(& &1 * 17 + 84 * 100 + 100_000) 
    |> Stream.reject(&is_prime/1) 
    |> Enum.count
  end

  defp is_prime(number) do
    number
    |> :math.sqrt
    |> trunc
    |> (& Range.new 2, &1).()
    |> Enum.all?(& rem(number, &1) != 0)
  end
end
