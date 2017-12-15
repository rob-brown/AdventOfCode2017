defmodule AdventOfCode.Day15B do

  def matches(input_a, input_b, rounds) do
    [
      input_a |> generate(16807) |> Stream.filter(& rem(&1, 4) == 0),
      input_b |> generate(48271) |> Stream.filter(& rem(&1, 8) == 0),
    ]
    |> Stream.zip
    |> Stream.take(rounds)
    |> Stream.filter(fn {x, y} -> <<x::16>> == <<y::16>> end)
    |> Enum.count
  end

  defp generate(start, factor) do
    Stream.resource(
      fn -> start end,
      fn x -> rem(x * factor, 2147483647) |> (&{[&1], &1}).() end,
      fn _ -> :ok end)
  end

  def test do
    1 = matches(65, 8921, 1056)
    309 = matches(65, 8921, 5_000_000)
    IO.puts "Test Passed"
  end

  def solve do
    matches 516, 190, 5_000_000
  end
end

