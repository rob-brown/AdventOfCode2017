defmodule AdventOfCode.Day13A do

  def severity(input) do
    input 
    |> Stream.reject(& &1 == "")
    |> Stream.map(&String.trim/1)
    |> Stream.map(& String.split &1, ": ")
    |> Stream.map(fn [depth, range] -> {String.to_integer(depth), String.to_integer(range)} end)
    |> Stream.filter(fn {depth, range} -> rem(depth, (range - 1) * 2) == 0 end)
    |> Enum.reduce(0, fn {depth, range}, acc -> acc + depth * range end)
  end

  def test do
    input = """
    0: 3
    1: 2
    4: 4
    6: 4
    """
    24 = input |> String.split("\n") |> severity
    IO.puts "Test Passed"
  end

  def solve do
    "day_13_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> severity
  end
end
