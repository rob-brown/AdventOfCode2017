defmodule AdventOfCode.Day8A do

  def highest_register(input) do
    input
    |> Stream.reject(& &1 == "")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_command/1)
    |> Enum.reduce(%{}, &eval/2)
    |> Enum.map(& elem(&1, 1))
    |> Enum.max
  end

  defp parse_command(command) when is_binary(command) do
    command |> String.split(" ") |> parse_command
  end
  defp parse_command([cmd_reg, cmd_op, cmd_value, "if", pred_reg, pred_op, pred_value]) do
    {
      {cmd_reg, cmd_to_fun(cmd_op), String.to_integer(cmd_value)},
      {pred_reg, cmd_to_fun(pred_op), String.to_integer(pred_value)}
    }
  end

  defp cmd_to_fun(">"),   do: &Kernel.>/2
  defp cmd_to_fun(">="),  do: &Kernel.>=/2
  defp cmd_to_fun("<"),   do: &Kernel.</2
  defp cmd_to_fun("<="),  do: &Kernel.<=/2
  defp cmd_to_fun("=="),  do: &Kernel.==/2
  defp cmd_to_fun("!="),  do: &Kernel.!=/2
  defp cmd_to_fun("inc"), do: &Kernel.+/2
  defp cmd_to_fun("dec"), do: &Kernel.-/2

  defp eval({command, predicate}, registers) do
    if evaluate_predicate predicate, registers do
      apply_fun command, registers
    else
      registers
    end
  end

  defp apply_fun({register, fun, value}, registers) do
    Map.get(registers, register, 0) |> fun.(value) |> (& Map.put(registers, register, &1)).()
  end

  defp evaluate_predicate({register, fun, value}, registers) do
    Map.get(registers, register, 0) |> fun.(value)
  end

  def test do
    input = """
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
    """
    1 = input |> String.split("\n") |> highest_register
    IO.puts "Test Passed"
  end

  def solve do
    "day_8_input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> highest_register
  end
end
