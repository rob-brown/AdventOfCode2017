defmodule Parallel do

  def map(items, fun) do
    ref = make_ref()
    me = self()
    items
    |> Enum.map(& spawn fn -> send me, {self(), ref, fun.(&1)} end)
    |> Enum.map(& receive do {^&1, ^ref, result} -> result end)
  end
  
  def map_unordered(items, fun) do
    ref = make_ref()
    me = self()
    items
    |> Enum.map(& spawn fn -> send me, { ref, fun.(&1)} end)
    |> Enum.map(fn _ -> receive do {^ref, result} -> result end end)
  end
end
