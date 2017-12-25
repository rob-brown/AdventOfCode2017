defmodule AdventOfCode do
  
  def solve_all do
    print_header()
    (for day <- 1..25, part <- ["A", "B"], do: {day, part})
    |> Stream.map(&run/1)
    #|> Parallel.map(&run/1)
    |> Stream.each(&print/1)
    |> print_total_time
  end
  
  defp run({day, part}) do
    try do
      module = "Elixir.AdventOfCode.Day#{day}#{part}" |> String.to_atom
      {time, solution} = :timer.tc module, :solve, []
      {day, part, time, solution}
    catch
      _ ->
        {day, part, 0, :error}
    rescue 
      _ ->
        {day, part, 0, :error}
    end
  end

  defp print_header do
    [
      String.pad_leading("Day", 3),
      String.pad_leading("Part", 4),
      String.pad_leading("Time", 14),
      String.pad_leading("Solution", 34),
    ]
    |> Enum.join(" | ")
    |> IO.puts
    String.pad_leading("", 64, "-")
    |> IO.puts
  end

  defp print({day, part, _, :error}) do
    [
      day |> to_string |> String.pad_leading(3),
      part |> to_string |> String.pad_leading(4),
      String.pad_leading("", 14),
      String.pad_leading("Failed", 34),
    ]
    |> Enum.join(" | ")
    |> IO.puts
  end
  defp print({day, part, time, solution}) do
    [
      day |> to_string |> String.pad_leading(3),
      part |> to_string |> String.pad_leading(4),
      time |> format_time |> String.pad_leading(14),
      solution |> to_string |> String.pad_leading(34),
    ]
    |> Enum.join(" | ")
    |> IO.puts
  end

  defp print_total_time(results) do
    results
    |> Stream.map(& elem &1, 2)
    |> Enum.sum
    |> (&"\nTotal time: #{format_time &1}").()
    |> IO.puts
  end

  defp format_time(t) when t > 60 * 1_000_000 do
    "#{t / (60 * 1_000_000)} m"
  end
  defp format_time(t) when t > 1_000_000 do
    "#{t / 1_000_000} s"
  end
  defp format_time(t) when t > 1000 do
    "#{t / 1000} ms"
  end
  defp format_time(t) do 
    "#{t} us"
  end
end
