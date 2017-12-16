defmodule AdventOfCode.Day16A do

  def dance(input, dancers) do
    input
    |> String.trim
    |> String.split(",")
    |> Stream.reject(& &1 == "")
    |> Enum.to_list
    |> process(dancers)
    |> Enum.join
  end

  defp process([], dancers), do: dancers
  defp process([<<"s", n::binary>> | rest], dancers) do
    new_dancers = dancers |> spin(String.to_integer(n))
    process rest, new_dancers
  end
  defp process([<<"x", names::binary>> | rest], dancers) do
    [a, b] = String.split(names, "/")
    new_dancers = exchange String.to_integer(a), String.to_integer(b), dancers
    process rest, new_dancers
  end
  defp process([<<"p", indices::binary>> | rest], dancers) do
    [a, b] = String.split(indices, "/")
    new_dancers = partner a, b, dancers
    process rest, new_dancers
  end

  defp spin(list, amount) do
    {first, second} = Enum.split list, -amount
    second ++ first
  end

  defp exchange(index_a, index_b, dancers) do
    a = Enum.at dancers, index_a
    b = Enum.at dancers, index_b
    dancers
    |> List.replace_at(index_a, b)
    |> List.replace_at(index_b, a)
  end

  defp partner(name_a, name_b, dancers) do
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

  def test do
    "baedc" = dance("s1,x3/4,pe/b", String.codepoints("abcde"))
    IO.puts "Test passed"
  end

  def solve do
    dancers = "abcdefghijklmnop" |> String.codepoints
    "day_16_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> dance(dancers)
  end
end
