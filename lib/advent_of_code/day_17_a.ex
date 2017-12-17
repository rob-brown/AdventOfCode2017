defmodule AdventOfCode.Day17A do

  def spinlock(input) do
    1..2017
    |> Enum.reduce({[0], 0}, fn value, {list, index} -> advance list, index, input, value end)
    |> (fn {list, index} -> Enum.at list, index + 1 end).()
  end

  defp advance(list, index, step, value) do
    next = Integer.mod(index + step, Enum.count(list)) + 1
    new_list = List.insert_at list, next, value
    {new_list, next}
  end

  def test do
    638 = spinlock 3
    IO.puts "Test Passed"
  end

  def solve do
    spinlock 337
  end
end
