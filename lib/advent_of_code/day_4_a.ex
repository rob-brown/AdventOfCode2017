defmodule AdventOfCode.Day4A do

  def valid_passphrases(input) do
    input
    |> Stream.reject(&dupes?/1)
    |> Enum.count
  end

  def test do
    2 = valid_passphrases [
      "aa bb cc dd ee",
      "aa bb cc dd aa",
      "aa bb cc dd aaa",
    ]
    IO.puts "Test Passed"
  end

  def solve do
    "day_4_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> valid_passphrases
  end

  defp dupes?(line) do
    line
    |> String.split
    |> (& Enum.count(&1) != (&1 |> Enum.uniq |> Enum.count)).()
  end
end
