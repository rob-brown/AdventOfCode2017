defmodule AdventOfCode.Day5B.ZipList do

  def steps(input) do
    input
    |> ZipList.from_list
    |> elem(1)
    |> execute(0)
  end

  defp execute(z = %ZipList{current: 0}, n) do
    z |> ZipList.set_current(1) |> execute(n + 1)
  end
  defp execute(z = %ZipList{current: value, remaining: r}, n) when value > 0 and value <= length(r) do
    z |> ZipList.set_current(augment_jump(value)) |> ZipList.advance(value) |> execute(n + 1)
  end
  defp execute(z = %ZipList{current: value, previous: p}, n) when value < 0 and abs(value) <= length(p) do
    z |> ZipList.set_current(augment_jump(value)) |> ZipList.retreat(abs(value)) |> execute(n + 1)
  end
  defp execute(_, n), do: n + 1

  defp augment_jump(n) when n < 3, do: n + 1
  defp augment_jump(n), do: n - 1

  def test do
    10 = steps([0, 3, 0, 1, -3])
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

defmodule AdventOfCode.Day5B do

  def steps(input) do
    input
    |> Stream.with_index
    |> Stream.map(fn {x, y} -> {y, x} end)
    |> Enum.into(%{})
    |> execute(0, 0)
  end

  defp execute(map, index, n) do
    case Map.get(map, index) do
      nil ->
        n
      value when value >= 3 ->
        map |> Map.put(index, value - 1) |> execute(index + value, n + 1)
      value ->
        map |> Map.put(index, value + 1) |> execute(index + value, n + 1)
    end
  end

  def test do
    10 = steps([0, 3, 0, 1, -3])
    IO.puts "Test Passed"
  end

  def solve do
    "day_5_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> Stream.map(& &1 |> String.trim |> String.to_integer)
    |> steps
  end
end

