defmodule AdventOfCode.Day9B do

  def count_garbage(input) do
    process(input, %{total: 0, stack: [0], garbage: 0}, :normal).garbage
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
  defp process(<<_, rest::binary>>, r = %{garbage: garbage}, :in_garbage) do
    new_result = %{r | garbage: garbage + 1}
    process rest, new_result, :in_garbage 
  end
  defp process(<<_, rest::binary>>, result, state) do
    process rest, result, state
  end

  def test do
    0 = count_garbage("<>")
    17 = count_garbage("<random characters>")
    3 = count_garbage("<<<<>")
    2 = count_garbage("<{!>}>")
    0 = count_garbage("<!!>")
    0 = count_garbage("<!!!>>")
    10 = count_garbage("<{o\"i!a,<{i<a>")
    IO.puts "Test Passed"
  end

  def solve do
    "day_9_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> count_garbage
  end
end

