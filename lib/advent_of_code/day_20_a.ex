defmodule AdventOfCode.Day20A do

  def simulate(input, iterations) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.reject(& &1 == "")
    |> Stream.with_index
    |> Stream.map(&parse/1)
    |> run(iterations)
    |> Enum.min_by(&manhattan_distance/1)
    |> (& &1.index).()
  end

  defp parse({line, n}) do
    line
    |> (& Regex.scan ~r"<([-0-9]*),([-0-9]*),([-0-9]*)>", &1).()
    |> (fn [[_, px, py, pz], [_, vx, vy, vz], [_, ax, ay, az]] -> 
      %{
        acceleration: {String.to_integer(ax), String.to_integer(ay), String.to_integer(az)}, 
        velocity: {String.to_integer(vx), String.to_integer(vy), String.to_integer(vz)}, 
        position: {String.to_integer(px), String.to_integer(py), String.to_integer(pz)}, 
        index: n
      }
    end).()
  end

  defp run(particles, 0), do: particles
  defp run(particles, iterations) do
    particles
    |> Stream.map(&step/1)
    |> run(iterations - 1)
  end

  defp step(p = %{acceleration: {ax, ay, az}, velocity: {vx, vy, vz}, position: {px, py, pz}}) do
    with new_vx = vx + ax,
      new_vy = vy + ay,
      new_vz = vz + az,
      new_px = px + new_vx,
      new_py = py + new_vy,
      new_pz = pz + new_vz
    do
      %{p | acceleration: {ax, ay, az}, velocity: {new_vx, new_vy, new_vz}, position: {new_px, new_py, new_pz}}
    end
  end

  defp manhattan_distance(%{position: {x, y, z}}) do
    abs(x) + abs(y) + abs(z)
  end

  def test do
    input = """
    p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>
    p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>
    """
    0 = input |> String.split("\n") |> simulate(10)
    IO.puts "Test Passed"
  end

  def solve(iterations \\ 1000) do
    "day_20_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> simulate(iterations)
  end
end
