defmodule AdventOfCode.Day18A do

  def run(input) do
    try do
      input
      |> Stream.map(&String.trim/1)
      |> Stream.reject(& &1 == "")
      |> Stream.map(& &1 |> String.split(" ") |> process)
      |> Enum.to_list
      |> step(0, %{})
    catch
      value ->
        value
    end
  end

  defp process(["set", a, b]), do: {:set, parse(a), parse(b)}
  defp process(["snd", a]), do: {:snd, parse(a)}
  defp process(["add", a, b]), do: {:add, parse(a), parse(b)}
  defp process(["mul", a, b]), do: {:mul, parse(a), parse(b)}
  defp process(["mod", a, b]), do: {:mod, parse(a), parse(b)}
  defp process(["rcv", a]), do: {:rcv, parse(a)}
  defp process(["jgz", a, b]), do: {:jgz, parse(a), parse(b)}

  defp parse(string) do
    case Integer.parse(string) do
      {int, ""} ->
        int
      _ ->
        string
    end
  end

  defp step(commands, pc, env) do
    {new_pc, new_env} = commands |> Enum.at(pc) |> apply_cmd(pc, env)
    step commands, new_pc, new_env
  end

  defp apply_cmd({:set, a, b}, pc, env) do
    {pc + 1, Map.put(env, a, lookup(b, env))}
  end
  defp apply_cmd({:snd, a}, pc, env) do
    {pc + 1, Map.put(env, "sound", lookup(a, env))}
  end
  defp apply_cmd({:add, a, b}, pc, env) do
    value = lookup(a, env) + lookup(b, env)
    {pc + 1, Map.put(env, a, value)}
  end
  defp apply_cmd({:mul, a, b}, pc, env) do
    value = lookup(a, env) * lookup(b, env)
    {pc + 1, Map.put(env, a, value)}
  end
  defp apply_cmd({:mod, a, b}, pc, env) do
    value = rem(lookup(a, env), lookup(b, env))
    {pc + 1, Map.put(env, a, value)}
  end
  defp apply_cmd({:rcv, a}, pc, env) do
    if lookup(a, env) == 0 do
      {pc + 1, env}
    else
      throw lookup("sound", env)
    end
  end
  defp apply_cmd({:jgz, a, b}, pc, env) do
    if lookup(a, env) > 0 do
      {pc + lookup(b, env), env}
    else
      {pc + 1, env}
    end
  end
  

  defp lookup(int, _) when is_integer(int), do: int
  defp lookup(name, env) when is_binary(name), do: Map.get(env, name, 0)
  
  def test do
    input = """
    set a 1
    add a 2
    mul a a
    mod a 5
    snd a
    set a 0
    rcv a
    jgz a -1
    set a 1
    jgz a -2
    """
    4 = input |> String.split("\n") |> run
    IO.puts "Test Passed"
  end

  def solve do
    input = """
    set i 31
    set a 1
    mul p 17
    jgz p p
    mul a 2
    add i -1
    jgz i -2
    add a -1
    set i 127
    set p 826
    mul p 8505
    mod p a
    mul p 129749
    add p 12345
    mod p a
    set b p
    mod b 10000
    snd b
    add i -1
    jgz i -9
    jgz a 3
    rcv b
    jgz b -1
    set f 0
    set i 126
    rcv a
    rcv b
    set p a
    mul p -1
    add p b
    jgz p 4
    snd a
    set a b
    jgz 1 3
    snd b
    set f 1
    add i -1
    jgz i -11
    snd a
    jgz f -16
    jgz a -19
    """
    input |> String.split("\n") |> run
  end
end
