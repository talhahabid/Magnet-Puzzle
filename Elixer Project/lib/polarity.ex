defmodule Polarity do
  @moduledoc """
    Add your solver function below. You may add additional helper functions if you desire.
    Test your code by running 'mix test --seed 0' from the simple_tester_ex directory.
  """
  def polarity(board, specs) do
    rows = tuple_size(board)
    cols = String.length(elem(board, 0))

    solution = Stream.repeatedly(fn -> "X" end) |> Stream.take(cols) |> Enum.join() |> List.duplicate(rows) |> List.to_tuple()
    magnet_pairs = sort_magnets(board, specs, rows, cols)

    constraints = %{
      rows: rows,
      cols: cols,
      left_cur: List.duplicate(0, rows),
      right_cur: List.duplicate(0, rows),
      top_cur: List.duplicate(0, cols),
      bottom_cur: List.duplicate(0, cols),
      left_specs: specs["left"],
      right_specs: specs["right"],
      top_specs: specs["top"],
      bottom_specs: specs["bottom"]
    }

    solve(solution, magnet_pairs, constraints) || raise "No solution found"
  end

  defp sort_magnets(board, specs, rows, cols) do
    position_pairs = Stream.flat_map(0..(rows - 1), fn r ->
      Stream.flat_map(0..(cols - 1), fn c ->
        cond do
          c < cols - 1 && String.at(elem(board, r), c) == "L" && String.at(elem(board, r), c + 1) == "R" -> [{{r, c}, {r, c + 1}}]
          r < rows - 1 && String.at(elem(board, r), c) == "T" && String.at(elem(board, r + 1), c) == "B" -> [{{r, c}, {r + 1, c}}]
          true -> []
        end
      end)
    end) |> Enum.to_list()

    Enum.sort_by(position_pairs, fn {{r1, c1}, {r2, c2}} ->
      score = fn r, c ->
        Stream.concat(
          Stream.map(["left", "right"], fn dir -> if(elem(specs[dir], r) != -1, do: 2, else: 0) end),
          Stream.map(["top", "bottom"], fn dir -> if(elem(specs[dir], c) != -1, do: 2, else: 0) end)
        ) |> Enum.sum()
      end
      -(score.(r1, c1) + score.(r2, c2))
    end)
  end

  defp solve(solution, magnet_pairs, constraints) do
    case do_solve(solution, magnet_pairs, constraints) do
      {:ok, result} -> result
      _ -> nil
    end
  end

  defp do_solve(solution, [], constraints) do
    valid? = fn counts, specs -> Stream.zip(counts, Tuple.to_list(specs)) |> Stream.map(fn {count, spec} -> spec == -1 || count == spec end) |> Enum.all?() end
    constraint_checks = [ {constraints.left_cur, constraints.left_specs}, {constraints.right_cur, constraints.right_specs}, {constraints.top_cur, constraints.top_specs}, {constraints.bottom_cur, constraints.bottom_specs}]
    result = Stream.map(constraint_checks, fn {counts, specs} -> valid?.(counts, specs) end) |> Enum.all?()
    if result, do: {:ok, solution}, else: :error
  end

  defp do_solve(solution, [{{r1, c1}, {r2, c2}} | rest], constraints) do
    try_config([{update_solution(solution, r1, c1, "+", r2, c2, "-"), update_constraints(constraints, r1, c1, "+", r2, c2, "-")}, {update_solution(solution, r1, c1, "-", r2, c2, "+"), update_constraints(constraints, r1, c1, "-", r2, c2, "+")}, {solution, constraints}], rest)
  end

  defp try_config([], _), do: :error

  defp try_config([{sol, state} | rest], remaining) do
    if is_valid_state?(sol, state) do
      case do_solve(sol, remaining, state) do
        {:ok, result} -> {:ok, result}
        _ -> try_config(rest, remaining)
      end
    else
      try_config(rest, remaining)
    end
  end

  defp update_solution(solution, r1, c1, v1, r2, c2, v2) do
    solution |> put_value(r1, c1, v1) |> put_value(r2, c2, v2)
  end

  defp update_constraints(state, r1, c1, v1, r2, c2, v2) do
    update_single_position(state, r1, c1, v1) |> update_single_position(r2, c2, v2)
  end

  defp put_value(solution, row, col, value) do
    put_elem(solution, row, String.graphemes(elem(solution, row))|> List.replace_at(col, value)|> Enum.join())
  end

  defp update_single_position(state, r, c, symbol) do
    case symbol do
      "X" -> state
      "+" -> state |> Map.update!(:left_cur, &List.update_at(&1, r, fn x -> x + 1 end)) |> Map.update!(:top_cur, &List.update_at(&1, c, fn x -> x + 1 end))
      "-" -> state |> Map.update!(:right_cur, &List.update_at(&1, r, fn x -> x + 1 end)) |> Map.update!(:bottom_cur, &List.update_at(&1, c, fn x -> x + 1 end))
    end
  end

  defp is_valid_state?(solution, state) do
    constraint_valid? = fn counts, specs -> Stream.zip(counts, Tuple.to_list(specs)) |> Enum.reduce(true, fn {count, spec}, acc -> acc && (spec == -1 || count <= spec) end) end
    constraints_ok? = Enum.reduce_while([:left, :right, :top, :bottom], true, fn dir, _acc ->
      if constraint_valid?.(Map.get(state, :"#{dir}_cur"), Map.get(state, :"#{dir}_specs")),
        do: {:cont, true},
        else: {:halt, false}
    end)

    horizontal_ok = Stream.map(0..(state.rows - 1), fn r ->
      Stream.map(0..(state.cols - 2), fn c ->
        left = String.at(elem(solution, r), c)
        right = String.at(elem(solution, r), c + 1)
        left == "X" || right == "X" || left != right
      end) |> Enum.all?()
    end) |> Enum.all?()

    vertical_ok = horizontal_ok && Stream.map(0..(state.rows - 2), fn r ->
      Stream.map(0..(state.cols - 1), fn c ->
        top = String.at(elem(solution, r), c)
        bottom = String.at(elem(solution, r + 1), c)
        top == "X" || bottom == "X" || top != bottom
      end) |> Enum.all?()
    end) |> Enum.all?()

    constraints_ok? && horizontal_ok && vertical_ok
  end
end
