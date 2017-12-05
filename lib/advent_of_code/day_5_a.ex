defmodule AdventOfCode.Day5A do
  
  def steps(input) do
    input
    |> ZipList.from_list
    |> elem(1)
    |> execute(0)
  end

  defp execute(z = %ZipList{current: 0}, n) do
    z |> ZipList.set_current(1) |> execute(n + 1)
  end
  defp execute(z = %ZipList{current: value}, n) when value > 0 do
    if ZipList.can_advance?(z, value) do
      z |> ZipList.set_current(value + 1) |> ZipList.advance(value) |> execute(n + 1)
    else
      n + 1
    end 
  end
  defp execute(z = %ZipList{current: value}, n) when value < 0 do
    if ZipList.can_retreat?(z, abs(value)) do
      z |> ZipList.set_current(value + 1) |> ZipList.retreat(abs(value)) |> execute(n + 1)
    else
      n + 1
    end
  end

  def test do
    5 = steps([0, 3, 0, 1, -3])
    IO.puts "Test Passed"
  end

  def solve do
    "day_5_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> Enum.to_list
    |> Enum.map(& &1 |> String.trim |> String.to_integer)
    |> steps
  end
end

