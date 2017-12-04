defmodule AdventOfCode.Spiral do

  def neighbors({x, y}) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0} do
      {x + dx, y + dy}
    end
  end

  def index_stream do
    Stream.concat([{0, 0}], Stream.resource(&start/0, &next/1, &finish/1))
  end

  defp start, do: {{0, 0}, {:right, 1}}

  defp next(acc) do
    {next_values(acc), next_acc(acc)}
  end

  defp next_values({{x, y}, {:up, magnitude}}) do
    for n <- 1..magnitude, do: {x, y + n}
  end
  defp next_values({{x, y}, {:down, magnitude}}) do
    for n <- 1..magnitude, do: {x, y - n}
  end
  defp next_values({{x, y}, {:left, magnitude}}) do
    for n <- 1..magnitude, do: {x - n, y}
  end
  defp next_values({{x, y}, {:right, magnitude}}) do
    for n <- 1..magnitude, do: {x + n, y}
  end

  defp next_acc({{x, y}, {:up, magnitude}}) do
    {{x, y + magnitude}, {:left, magnitude + 1}}
  end
  defp next_acc({{x, y}, {:down, magnitude}}) do
    {{x, y - magnitude}, {:right, magnitude + 1}}
  end
  defp next_acc({{x, y}, {:left, magnitude}}) do
    {{x - magnitude, y}, {:down, magnitude}}
  end
  defp next_acc({{x, y}, {:right, magnitude}}) do
    {{x + magnitude, y}, {:up, magnitude}}
  end

  defp finish(_), do: :ok
end
