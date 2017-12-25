defmodule AdventOfCode.Day25A do

  def simulate(input) do
    input
    |> parse
    |> build_machine
    |> run
    |> (& &1.tape).()
    |> Map.values
    |> Enum.sum
  end

  defp parse(input) do
    input
    |> String.split("\n\n")
    |> parse_preamble
    |> parse_rules
  end

  defp parse_preamble([preamble | rest]) do
    with [_, state] = Regex.run(~r/Begin in state ([A-Z])/, preamble),
      [_, step_string] = Regex.run(~r/Perform a diagnostic checksum after (\d+) steps/, preamble),
      steps = String.to_integer(step_string)
    do
      {state, steps, rest}
    end
  end

  defp parse_rules(info, results \\ %{})
  defp parse_rules({initial, steps, []}, results), do: {initial, steps, results}
  defp parse_rules({initial, steps, [head | rest]}, results) do
    ~r/In state ([A-Z]):.*If the current value is 0:.* Write the value (0|1).*Move one slot to the (left|right).*Continue with state ([A-Z]).*If the current value is 1:.*Write the value (0|1).*Move one slot to the (left|right).*Continue with state ([A-Z])/ms
    |> Regex.run(head)
    |> (fn [_, state, write0, move0, next0, write1, move1, next1] -> 
        [
          {{state, 0}, {String.to_integer(write0), :"#{move0}", next0}},
          {{state, 1}, {String.to_integer(write1), :"#{move1}", next1}},
        ]
      end).()
    |> (& parse_rules({initial, steps, rest}, Enum.into(&1, results))).()
  end

  def build_machine({initial, steps, rules}) do
    %{state: initial, steps: steps, rules: rules, tape: %{}, cursor: 0}
  end

  defp run(m = %{steps: 0}), do: m
  defp run(m = %{steps: steps, rules: rules, tape: tape, state: state, cursor: cursor}) do
    rules
    |> Map.get({state, Map.get(tape, cursor, 0)})
    |> (fn {write, direction, next} ->
      %{m | 
        state: next, 
        cursor: move(cursor, direction), 
        tape: Map.put(tape, cursor, write), 
        steps: steps - 1
      }
    end).()
    |> run
  end

  defp move(cursor, :left), do: cursor - 1
  defp move(cursor, :right), do: cursor + 1

  def test do
    input = """
    Begin in state A.
    Perform a diagnostic checksum after 6 steps.

    In state A:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state B.
      If the current value is 1:
        - Write the value 0.
        - Move one slot to the left.
        - Continue with state B.

    In state B:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state A.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A.
    """
    3 = simulate input
    IO.puts "Test Passed"
  end

  def solve do
    "day_25_input.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> simulate
  end
end
