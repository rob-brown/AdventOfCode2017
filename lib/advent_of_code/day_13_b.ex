defmodule AdventOfCode.Day13B do

  def delay(input) do
    input 
    |> Stream.reject(& &1 == "")
    |> Stream.map(&String.trim/1)
    |> Stream.map(& String.split &1, ": ")
    |> Stream.map(fn [depth, range] -> {String.to_integer(depth), String.to_integer(range)} end)
    |> attempt(0)
  end

  defp attempt(scanners, delay) do
    if Enum.any?(scanners, (& collision &1, delay)) do
      attempt scanners, delay + 1
    else
      delay
    end
  end

  defp collision({depth, range}, delay) do
    rem((delay + depth), ((range - 1) * 2)) == 0
  end

  def test do
    input = """
    0: 3
    1: 2
    4: 4
    6: 4
    """
    10 = input |> String.split("\n") |> delay
    IO.puts "Test Passed"
  end

  def solve do
    "day_13_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> delay
  end
end

