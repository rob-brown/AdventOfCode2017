defmodule AdventOfCode.Day16B do

  def dance_repeat(input, dancers) do
    steps = process input
    dancers
    |> run_until_repeat(steps)
    |> (& Integer.mod 1_000_000_000, &1).()
    |> (& Range.new 1, &1).()
    |> Enum.reduce(String.codepoints(dancers), fn _, acc -> run acc, steps end)
    |> Enum.join
  end
  
  defp process(input) do
    input
    |> String.trim
    |> String.split(",")
    |> Stream.reject(& &1 == "")
    |> Stream.map(&process_step/1)
    |> Enum.to_list
  end

  defp process_step(<<"s", n::binary>>) do
    {:s, String.to_integer(n)}
  end
  defp process_step(<<"x", indices::binary>>) do
    [a, b] = String.split(indices, "/") |> Enum.map(&String.to_integer/1)
    {:x, a, b}
  end
  defp process_step(<<"p", names::binary>>) do
    [a, b] = String.split(names, "/") 
    {:p, a, b}
  end

  defp run_until_repeat(dancers, steps, count \\ 0, first \\ nil) do
    next = dancers |> String.codepoints |> run(steps) |> Enum.join
    if next == first do
      count
    else
      run_until_repeat next, steps, count + 1, first || next
    end
  end

  defp run(dancers, []), do: dancers
  defp run(dancers, [{:s, n} | rest]) do
    dancers |> spin(n) |> run(rest)
  end
  defp run(dancers, [{:x, a, b} | rest]) do
    dancers |> exchange(a, b) |> run(rest)
  end
  defp run(dancers, [{:p, a, b} | rest]) do
    dancers |> partner(a, b) |> run(rest)
  end

  defp spin(list, amount) do
    {first, second} = Enum.split list, -amount
    second ++ first
  end

  defp exchange(dancers, index_a, index_b) do
    a = Enum.at dancers, index_a
    b = Enum.at dancers, index_b
    dancers
    |> List.replace_at(index_a, b)
    |> List.replace_at(index_b, a)
  end

  defp partner(dancers, name_a, name_b) do
    Enum.map(dancers, fn x ->
      cond do
        x == name_a ->
          name_b
        x == name_b ->
          name_a
        true ->
          x
      end
    end)
  end

  def solve do
    dancers = "abcdefghijklmnop" 
    "day_16_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> dance_repeat(dancers)
  end
end

