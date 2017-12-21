defmodule AdventOfCode.Day21A do

  def fractal(input, rules_text, iterations) do
    grid = input |> parse_grid
    rules = rules_text |> String.split("\n") |> Stream.reject(& &1 == "") |> Enum.map(&parse_rule/1) |> optimize_rules
    grid
    |> expand(rules, iterations)
    |> Stream.filter(fn {_, value} -> value == "#" end)
    |> Enum.count
  end

  def parse_grid(lines) do
    lines
    |> String.split("\n")
    |> Stream.reject(& &1 == "")
    |> Stream.with_index
    |> Stream.flat_map(fn {row, y} -> 
      row |> String.codepoints|> Stream.with_index |> Stream.map(fn {a, x} -> {{x, y}, a} 
    end) end)
    |> Map.new
  end

  def parse_rule(line) do
    line
    |> String.trim
    |> String.split(" => ")
    |> (fn [from, to] -> 
      %{
        from: from |> String.replace("/", "\n") |> parse_grid,
        to: to |> String.replace("/", "\n") |> parse_grid,
      }
    end).()
  end

  def optimize_rules(rules) do
    rules
    |> Stream.flat_map(fn %{from: from, to: to} -> 
      from
      |> all_permutations
      |> Enum.map(&{&1, to})
    end)
    |> Map.new
  end

  defp expand(grid, _, 0), do: grid
  defp expand(grid, rules, iterations) do
    grid
    |> divide
    |> Stream.map(fn {{x, y}, g} -> {{x, y}, expand_chunk(g, rules)} end)
    |> combine
    |> expand(rules, iterations - 1)
  end

  def divide(grid) do
    size = grid_size(grid)
    cond do
      rem(size, 2) == 0 ->
        magnitude = div(size, 2) - 1
        for sx <- 0..magnitude, sy <- 0..magnitude, into: %{} do
          x_range = Range.new (2 * sx), (2 * sx + 1)
          y_range = Range.new (2 * sy), (2 * sy + 1)
          grid 
          |> Enum.filter(fn {{x, y}, _} -> x in x_range and y in y_range end) 
          |> Enum.map(fn {{x, y}, g} -> {{x - (2 * sx), y - (2 * sy)}, g} end)
          |> (& {{sx, sy}, Map.new(&1)}).()
        end
      rem(size, 3) == 0 ->
        magnitude = div(size, 3) - 1
        for sx <- 0..magnitude, sy <- 0..magnitude, into: %{} do
          x_range = Range.new (3 * sx), (3 * sx + 2)
          y_range = Range.new (3 * sy), (3 * sy + 2)
          grid 
          |> Enum.filter(fn {{x, y}, _} -> x in x_range and y in y_range end) 
          |> Enum.map(fn {{x, y}, g} -> {{x - (3 * sx), y - (3 * sy)}, g} end)
          |> (& {{sx, sy}, Map.new(&1)}).()
        end
    end
  end

  defp expand_chunk(grid, rules) do
    Map.fetch! rules, grid
  end

  def combine(chunks) do
    size = chunks |> Stream.map(fn {_, x} -> grid_size x end) |> Enum.at(0)
    chunks
    |> Stream.flat_map(fn {{sx, sy}, grid} -> Enum.map(grid, fn {{x, y}, value} -> {{x + (sx * size), y + (sy * size)}, value} end) end)
    |> Map.new
  end

  defp grid_size(grid) do
    grid |> Enum.count |> :math.sqrt |> trunc
  end
 
  def rotate(%{{0, 0} => a, {1, 0} => b, {2, 0} => c, {0, 1} => d, {1, 1} => e, {2, 1} => f, {0, 2} => g, {1, 2} => h, {2, 2} => i}) do
    %{
      {0, 0} => g,
      {1, 0} => d,
      {2, 0} => a,
      {0, 1} => h,
      {1, 1} => e,
      {2, 1} => b,
      {0, 2} => i, 
      {1, 2} => f,
      {2, 2} => c,
    }
  end
  def rotate(%{{0, 0} => a, {1, 0} => b, {0, 1} => c, {1, 1} => d}) do
    %{
      {0, 0} => c,
      {1, 0} => a,
      {0, 1} => d,
      {1, 1} => b,
    }
  end

  def all_rotations(grid) do
    with rot90 = rotate(grid),
      rot180 = rotate(rot90),
      rot270 = rotate(rot180)
    do
      [grid, rot90, rot180, rot270]
    end
  end

  def flip_vertical(%{{0, 0} => a, {1, 0} => b, {2, 0} => c, {0, 1} => d, {1, 1} => e, {2, 1} => f, {0, 2} => g, {1, 2} => h, {2, 2} => i}) do
    %{
      {0, 0} => g,
      {1, 0} => h,
      {2, 0} => i,
      {0, 1} => d,
      {1, 1} => e,
      {2, 1} => f,
      {0, 2} => a, 
      {1, 2} => b,
      {2, 2} => c,
    }
  end
  def flip_vertical(%{{0, 0} => a, {1, 0} => b, {0, 1} => c, {1, 1} => d}) do
    %{
      {0, 0} => c,
      {1, 0} => d,
      {0, 1} => a,
      {1, 1} => b,
    }
  end

  def flip_horizontal(%{{0, 0} => a, {1, 0} => b, {2, 0} => c, {0, 1} => d, {1, 1} => e, {2, 1} => f, {0, 2} => g, {1, 2} => h, {2, 2} => i}) do
    %{
      {0, 0} => c,
      {1, 0} => b,
      {2, 0} => a,
      {0, 1} => f,
      {1, 1} => e,
      {2, 1} => d,
      {0, 2} => i, 
      {1, 2} => h,
      {2, 2} => g,
    }
  end
  def flip_horizontal(%{{0, 0} => a, {1, 0} => b, {0, 1} => c, {1, 1} => d}) do
    %{
      {0, 0} => b,
      {1, 0} => a,
      {0, 1} => d,
      {1, 1} => c,
    }
  end

  def all_flips(grid) do
    with flip_h = flip_horizontal(grid),
      flip_v = flip_vertical(grid),
      flip_hv = flip_vertical(flip_h)
    do
      [grid, flip_h, flip_v, flip_hv]
    end
  end
     
  def all_permutations(grid) do
    grid |> all_rotations |> Enum.flat_map(&all_flips/1)
  end   
 
  def print(grid) do
    size = grid_size grid
    range = 0..(size - 1)
    string = 
      for y <- range, into: "" do
        for x <- range, into: "" do
          Map.get grid, {x, y}
        end
        |> (& &1 <> "\n").()
      end
    IO.puts string
    string
  end

  def test do
    input = """
    .#.
    ..#
    ###
    """
    rules = """
    ../.# => ##./#../...
    .#./..#/### => #..#/..../..../#..#
    """
    12 = fractal(input, rules, 2)
    IO.puts "Test Passed"
  end

  def solve do
    input = """
    .#.
    ..#
    ###
    """
    "day_21_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> (& fractal input, &1, 5).()
  end
end
