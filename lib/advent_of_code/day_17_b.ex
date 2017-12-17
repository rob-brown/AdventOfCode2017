defmodule AdventOfCode.Day17B do

  def spinlock(input) do
    1..50_000_000
    |> Enum.reduce({0, 0}, fn value, {index, result} ->
      new_index = rem(index + input, value) + 1
      if new_index == 1 do
        {new_index, value}
      else
        {new_index, result}
      end
    end)
    |> (& elem &1, 1).()
  end

  def test do
    1_222_153 = spinlock 3
    IO.puts "Test Passed"
  end

  def solve do
    spinlock 337
  end
end
