defmodule AdventOfCode.Day4B do

  def valid_passphrases(input) do
    input
    |> Stream.reject(&dupes_or_anagrams?/1)
    |> Enum.count
  end

  defp dupes_or_anagrams?(line) do
    line
    |> String.split
    |> Stream.map(& &1 |> String.codepoints |> Enum.sort |> Enum.join)
    |> (& Enum.count(&1) != (&1 |> Enum.uniq |> Enum.count)).()
  end

  def test do
    3 = valid_passphrases [
      "abcde fghij",
      "abcde xyz ecdab",
      "a ab abc abd abf abj",
      "iiii oiii ooii oooi oooo",
      "oiii ioii iioi iiio",
    ]
    IO.puts "Test Passed"
  end

  def solve do
    "day_4_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> valid_passphrases
  end
end
