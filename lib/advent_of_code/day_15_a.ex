defmodule AdventOfCode.Day15A do

  def matches(input_a, input_b, rounds) do
    [
      generate(input_a, 16807),
      generate(input_b, 48271),
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
    1 = matches(65, 8921, 5)
    IO.puts "Test Passed"
  end

  def solve do
    matches 516, 190, 40_000_000
  end
end
