defmodule AdventOfCode.Day18B do

  def run(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.reject(& &1 == "")
    |> Stream.map(& &1 |> String.split(" ") |> parse)
    |> Enum.to_list
    |> (& %{0 => spawn_process(&1, 0), 1 => spawn_process(&1, 1)}).()
    |> run_till_block
    |> Map.get(1)
    |> (& &1.env).()
    |> Map.get("sent")
  end

  defp spawn_process(commands, pid) do
    %{state: :idle, commands: commands, pid: 0, pc: 0, env: %{"p" => pid, "queue" => [], "sent" => 0}}
  end
  
  defp run_till_block(processes) do
    case next_process(processes) do
      nil ->
        processes
      {pid, process} ->
        {state, pc, env} = step process.commands, process.pc, process.env
        case state do
          {:send, value} ->
            other_pid = pid == 0 && 1 || 0
            other_process = Map.get(processes, other_pid)
            new_env = other_process.env |> Map.update("queue", [], fn queue -> queue ++ [value] end)
            run_till_block %{
              pid => %{process | state: :idle, pc: pc, env: env}, 
              other_pid => %{other_process | env: new_env},
            }
          _ ->
            new_process = %{process | state: state, pc: pc, env: env}
            new_processes = %{processes | pid => new_process}
            run_till_block new_processes
        end
    end
  end

  defp next_process(processes = %{}) do
    Enum.find(processes, fn {_, process} ->
      process.state == :idle or (process.state == :rcv and Enum.empty?(process.env["queue"]) == false)
    end)
  end

  defp parse(["set", a, b]), do: {:set, parse(a), parse(b)}
  defp parse(["snd", a]), do: {:snd, parse(a)}
  defp parse(["add", a, b]), do: {:add, parse(a), parse(b)}
  defp parse(["mul", a, b]), do: {:mul, parse(a), parse(b)}
  defp parse(["mod", a, b]), do: {:mod, parse(a), parse(b)}
  defp parse(["rcv", a]), do: {:rcv, parse(a)}
  defp parse(["jgz", a, b]), do: {:jgz, parse(a), parse(b)}

  defp parse(string) do
    case Integer.parse(string) do
      {int, ""} ->
        int
      _ ->
        string
    end
  end

  defp step(commands, pc, env) do
    case Enum.at(commands, pc) do
      nil ->
        {:term, pc, env}
      command -> 
        case apply_cmd(command, pc, env) do
          {:idle, new_pc, new_env} ->
            step commands, new_pc, new_env
          state ->  
            state
        end
    end
  end

  defp apply_cmd({:set, a, b}, pc, env) do
    {:idle, pc + 1, Map.put(env, a, lookup(b, env))}
  end
  defp apply_cmd({:snd, a}, pc, env) do
    new_env = env |> Map.update("sent", 0, & &1 + 1)
    {{:send, lookup(a, env)}, pc + 1, new_env}
  end
  defp apply_cmd({:add, a, b}, pc, env) do
    value = lookup(a, env) + lookup(b, env)
    {:idle, pc + 1, Map.put(env, a, value)}
  end
  defp apply_cmd({:mul, a, b}, pc, env) do
    value = lookup(a, env) * lookup(b, env)
    {:idle, pc + 1, Map.put(env, a, value)}
  end
  defp apply_cmd({:mod, a, b}, pc, env) do
    value = rem(lookup(a, env), lookup(b, env))
    {:idle, pc + 1, Map.put(env, a, value)}
  end
  defp apply_cmd({:rcv, a}, pc, env) do
    case env["queue"] do
      [head | rest] ->
        new_env = env |> Map.put(a, head) |> Map.put("queue", rest)
        {:idle, pc + 1, new_env}
      [] ->
        {:rcv, pc, env}
    end
  end
  defp apply_cmd({:jgz, a, b}, pc, env) do
    if lookup(a, env) > 0 do
      {:idle, pc + lookup(b, env), env}
    else
      {:idle, pc + 1, env}
    end
  end
  

  defp lookup(int, _) when is_integer(int), do: int
  defp lookup(name, env) when is_binary(name), do: Map.get(env, name, 0)
  
  def test do
    input = """
    snd 1
    snd 2
    snd p
    rcv a
    rcv b
    rcv c
    rcv d
    """
    3 = input |> String.split("\n") |> run
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

