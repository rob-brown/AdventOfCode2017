defmodule AdventOfCode.Day9A do

  def score(input) do
    process(input, %{total: 0, stack: [0]}, :normal).total
  end

  defp process(<<>>, result, _), do: result
  defp process(<<"!", _, rest::binary>>, result, :in_garbage) do
    process rest, result, :in_garbage
  end
  defp process(<<"<", rest::binary>>, result, :normal) do
    process rest, result, :in_garbage
  end
  defp process(<<">", rest::binary>>, result, :in_garbage) do
    process rest, result, :normal
  end
  defp process(<<"{", rest::binary>>, r = %{stack: [head | tail]}, :normal) do
    new_result = %{r | stack: [head + 1, head | tail]}
    process rest, new_result, :normal
  end
  defp process(<<"}", rest::binary>>, r = %{total: total, stack: [head | tail]}, :normal) do
    new_result = %{r | total: total + head, stack: tail}
    process rest, new_result, :normal
  end
  defp process(<<_, rest::binary>>, result, s) do
    process rest, result, s
  end

  def test do
    1 = score("{}")
    6 = score("{{{}}}")
    5 = score("{{},{}}")
    16 = score("{{{},{},{{}}}}")
    1 = score("{<a>,<a>,<a>,<a>}")
    9 = score("{{<ab>},{<ab>},{<ab>},{<ab>}}")
    9 = score("{{<!!>},{<!!>},{<!!>},{<!!>}}")
    3 = score("{{<a!>},{<a!>},{<a!>},{<ab>}}")
    IO.puts "Test Passed"
  end

  def solve do
    "day_9_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> score
  end
end
