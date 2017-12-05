defmodule ZipList do
  defstruct previous: [], current: nil, remaining: []

  def from_list(list, index \\ 0)
  def from_list([], _), do: {:error, :empty_list}
  def from_list(list, index) when length(list) < index, do: {:error, :index_out_of_bounds}
  def from_list(list, index) when is_list(list) do
    previous = list |> Enum.take(index) |> Enum.reverse
    [current | remaining] = Enum.drop list, index
    ziplist = %__MODULE__{previous: previous, current: current, remaining: remaining}
    {:ok, ziplist}
  end

  def to_list(z = %__MODULE__{}) do
    tail = [z.current | z.remaining]
    Enum.reverse z.previous, tail
  end

  def previous?(%__MODULE__{previous: previous}), do: previous != []

  def remaining?(%__MODULE__{remaining: remaining}), do: remaining != []

  def can_advance?(%__MODULE__{remaining: remaining}, n) do
    n <= Enum.count(remaining)
  end

  def can_retreat?(%__MODULE__{previous: previous}, n) do
    n <= Enum.count(previous)
  end

  def advance(z = %__MODULE__{remaining: []}), do: z
  def advance(z = %__MODULE__{remaining: [remaining | rest]}) do
    %__MODULE__{previous: [z.current | z.previous], current: remaining, remaining: rest}
  end

  def advance(z = %__MODULE__{}, n) do
    Enum.reduce(1..n, z, fn _, acc -> ZipList.advance(acc) end)
  end

  def retreat(z = %__MODULE__{previous: []}), do: z
  def retreat(z = %__MODULE__{previous: [previous | rest]}) do
    %__MODULE__{previous: rest, current: previous, remaining: [z.current | z.remaining]}
  end

  def retreat(z = %__MODULE__{}, n) do
    Enum.reduce(1..n, z, fn _, acc -> ZipList.retreat(acc) end)
  end

  def current_index(z = %__MODULE__{}), do: Enum.count(z.previous) + 1

  def set_current(ziplist, value) do
    %__MODULE__{ziplist | current: value}
  end
end

defimpl Enumerable, for: ZipList do
  def count(%ZipList{remaining: remaining, previous: previous}) do
    count = Enum.count(remaining) + Enum.count(previous) + 1
    {:ok, count}
  end
  def member?(%ZipList{previous: previous, current: current, remaining: remaining}, value) do
    result = current == value or Enum.member?(previous, value) or Enum.member?(remaining, value)
    {:ok, result}
  end
  def reduce(ziplist, acc, fun) do
    ziplist |> ZipList.to_list |> Enumerable.List.reduce(acc, fun)
  end
end

defimpl Collectable, for: ZipList do
  def into(ziplist) do
    {{ziplist, []}, fn
      {ziplist, values}, {:cont, item} -> {ziplist, [item | values]}
      {ziplist, values}, :done -> %ZipList{ziplist | remaining: ziplist.remaining ++ Enum.reverse(values)}
      _, :halt -> :ok
    end}
  end
end
