defmodule AdventOfCode.Day15A do

  def generate(input_a, input_b, rounds) do
    stream_a = generate_stream(input_a, 16807)
    stream_b = generate_stream(input_b, 48271)
    Stream.zip([stream_a, stream_b])
    |> Stream.take(rounds)
    |> Stream.map(fn {x, y} -> {<<x::64>>, <<y::64>>} end)
    |> Stream.map(fn {x, y} -> {binary_part(x, byte_size(x), -2), binary_part(y, byte_size(y), -2)} end)
    |> Stream.filter(fn {x, y} -> x == y end)
    |> Enum.count
  end

  defp generate_stream(input, factor) do
    Stream.resource(
      fn -> input end,
      fn acc -> 
        value = rem(acc * factor, 2147483647)
        {[value], value}
      end,
      fn _ -> :ok end)
  end

  def test do
    1 = generate(65, 8921, 5)
    IO.puts "Test Passed"
  end

  def solve do
    generate 516, 190, 40_000_000
  end
end
