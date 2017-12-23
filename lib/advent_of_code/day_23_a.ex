defmodule AdventOfCode.Day23A do

  def run(input) do
      input
      |> Stream.map(&String.trim/1)
      |> Stream.reject(& &1 == "")
      |> Stream.map(& &1 |> String.split(" ") |> process)
      |> Enum.to_list
      |> step(0, %{"mul" => 0})
  end

  defp process(["set", a, b]), do: {:set, parse(a), parse(b)}
  defp process(["sub", a, b]), do: {:sub, parse(a), parse(b)}
  defp process(["mul", a, b]), do: {:mul, parse(a), parse(b)}
  defp process(["jnz", a, b]), do: {:jnz, parse(a), parse(b)}

  defp parse(string) do
    case Integer.parse(string) do
      {int, ""} ->
        int
      _ ->
        string
    end
  end

  defp step(commands, pc, env) do
    case commands |> Enum.at(pc, :done) |> apply_cmd(pc, env) do
      {new_pc, new_env} ->
        step commands, new_pc, new_env
      result ->
        result
    end
  end

  defp apply_cmd(:done, pc, env), do: Map.get(env, "mul")
  defp apply_cmd({:set, a, b}, pc, env) do
    {pc + 1, Map.put(env, a, lookup(b, env))}
  end
  defp apply_cmd({:sub, a, b}, pc, env) do
    value = lookup(a, env) - lookup(b, env)
    {pc + 1, Map.put(env, a, value)}
  end
  defp apply_cmd({:mul, a, b}, pc, env) do
    value = lookup(a, env) * lookup(b, env)
    new_env = env |> Map.put(a, value) |> Map.update("mul", 0, (& &1 + 1))
    {pc + 1, new_env}
  end
  defp apply_cmd({:jnz, a, b}, pc, env) do
    if lookup(a, env) != 0  do
      {pc + lookup(b, env), env}
    else
      {pc + 1, env}
    end
  end
  

  defp lookup(int, _) when is_integer(int), do: int
  defp lookup(name, env) when is_binary(name), do: Map.get(env, name, 0)
  
  def solve do
    "day_23_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split("\n") 
    |> run
  end
end
