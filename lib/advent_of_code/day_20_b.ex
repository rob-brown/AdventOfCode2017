defmodule AdventOfCode.Day20B do

  def simulate(input, iterations) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.reject(& &1 == "")
    |> Stream.with_index
    |> Stream.map(&parse/1)
    |> run(iterations)
    |> Enum.count
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
    |> remove_collisions
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

  defp remove_collisions(particles) do
    particles
    |> Enum.group_by(& &1.position)
    |> Stream.reject(fn {_, bucket} -> Enum.count(bucket) > 1 end)
    |> Stream.map(fn {_, [value]} -> value end)
  end

  def test do
    input = """
    p=<-6,0,0>, v=<3,0,0>, a=<0,0,0>    
    p=<-4,0,0>, v=<2,0,0>, a=<0,0,0>
    p=<-2,0,0>, v=<1,0,0>, a=<0,0,0>
    p=<3,0,0>, v=<-1,0,0>, a=<0,0,0>
    """
    1 = input |> String.split("\n") |> simulate(10)
    IO.puts "Test Passed"
  end

  def solve(iterations \\ 1000) do
    "day_20_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> simulate(iterations)
  end
end

