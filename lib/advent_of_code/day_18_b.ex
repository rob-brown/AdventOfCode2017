defmodule AdventOfCode.Day18B do
  import Kernel, except: [apply: 3]

  def run_async(input) do
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
    %{state: :idle, commands: commands, pc: 0, env: %{"p" => pid, "queue" => [], "sent" => 0}}
  end
  
  defp run_till_block(processes) do
    with {pid, process} <- next_process(processes),
      other_pid = pid == 0 && 1 || 0,
      {state, pc, env, msg} <- step(process.commands, process.pc, process.env)
    do
      processes 
      |> send_msg(msg, other_pid) 
      |> Map.update!(pid, & %{&1 | state: state, pc: pc, env: env}) 
      |> run_till_block
    else
      :none_ready ->
        processes
    end
  end

  defp next_process(processes = %{}) do
    Enum.find(processes, :none_ready, fn 
      {_, %{state: :idle}} -> true
      {_, %{state: :rcv, env: env}} -> Enum.empty?(env["queue"]) == false
      _ -> false
    end)
  end

  defp parse(["set", a, b]), do: {:set, parse_arg(a), parse_arg(b)}
  defp parse(["snd", a]),    do: {:snd, parse_arg(a)}
  defp parse(["add", a, b]), do: {:add, parse_arg(a), parse_arg(b)}
  defp parse(["mul", a, b]), do: {:mul, parse_arg(a), parse_arg(b)}
  defp parse(["mod", a, b]), do: {:mod, parse_arg(a), parse_arg(b)}
  defp parse(["rcv", a]),    do: {:rcv, parse_arg(a)}
  defp parse(["jgz", a, b]), do: {:jgz, parse_arg(a), parse_arg(b)}

  defp parse_arg(string) do
    case Integer.parse(string) do
      {int, ""} ->
        int
      _ ->
        string
    end
  end

  defp send_msg(processes, nil, _), do: processes
  defp send_msg(processes, message, pid) do
    update_in processes, [pid, :env, "queue"], (& &1 ++ [message])
  end

  defp step(commands, pc, env) do
    commands |> Enum.at(pc, :done) |> apply(pc, env)
  end

  defp apply(:done, pc, env) do
    {:done, pc, env, nil}
  end
  defp apply({:set, a, b}, pc, env) do
    {:idle, pc + 1, Map.put(env, a, eval(b, env)), nil}
  end
  defp apply({:snd, a}, pc, env) do
    new_env = env |> Map.update("sent", 0, & &1 + 1)
    message = eval(a, env)
    {:idle, pc + 1, new_env, message}
  end
  defp apply({:add, a, b}, pc, env) do
    value = eval(a, env) + eval(b, env)
    {:idle, pc + 1, Map.put(env, a, value), nil}
  end
  defp apply({:mul, a, b}, pc, env) do
    value = eval(a, env) * eval(b, env)
    {:idle, pc + 1, Map.put(env, a, value), nil}
  end
  defp apply({:mod, a, b}, pc, env) do
    value = rem(eval(a, env), eval(b, env))
    {:idle, pc + 1, Map.put(env, a, value), nil}
  end
  defp apply({:rcv, a}, pc, env) do
    case env["queue"] do
      [head | rest] ->
        new_env = env |> Map.put(a, head) |> Map.put("queue", rest)
        {:idle, pc + 1, new_env, nil}
      [] ->
        {:rcv, pc, env, nil}
    end
  end
  defp apply({:jgz, a, b}, pc, env) do
    if eval(a, env) > 0 do
      {:idle, pc + eval(b, env), env, nil}
    else
      {:idle, pc + 1, env, nil}
    end
  end

  defp eval(int, _) when is_integer(int), do: int
  defp eval(name, env) when is_binary(name), do: Map.get(env, name, 0)
  
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
    3 = input |> String.split("\n") |> run_async
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
    input |> String.split("\n") |> run_async
  end
end

