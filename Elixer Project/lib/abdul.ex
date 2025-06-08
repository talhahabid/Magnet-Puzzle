# defmodule Polarity do
#   @moduledoc """
#     Add your solver function below. You may add additional helper functions if you desire.
#     Test your code by running 'mix test --seed 0' from the simple_tester_ex directory.
#   """
#   def polarity(board, specs) do
#     rows = tuple_size(board)
#     cols = String.length(elem(board, 0))

#     init_sol = init_grid(rows, cols)

#     pairs = find_pairs(board)

#     sorted = sort_pairs(pairs, specs, rows, cols)

#     state = init_state(rows, cols, specs)

#     case solve(board, init_sol, sorted, state) do
#       {:ok, sol} -> to_string_sol(sol, rows)
#       _ -> raise "No solution found"
#     end
#   end

#   defp init_grid(rows, cols) do
#     for _ <- 1..rows, do: List.duplicate("X", cols)
#   end

#   defp init_state(rows, cols, specs) do
#     %{
#       rows: rows,
#       cols: cols,
#       plus_rows: List.duplicate(0, rows),
#       minus_rows: List.duplicate(0, rows),
#       plus_cols: List.duplicate(0, cols),
#       minus_cols: List.duplicate(0, cols),
#       left_constraints: specs["left"],
#       right_constraints: specs["right"],
#       top_constraints: specs["top"],
#       bottom_constraints: specs["bottom"]
#     }
#   end

#   defp find_pairs(board) do
#     rows = tuple_size(board)
#     cols = String.length(elem(board, 0))

#     h_pairs = for r <- 0..(rows-1), c <- 0..(cols-2) do
#       left = String.at(elem(board, r), c)
#       right = String.at(elem(board, r), c+1)
#       if left == "L" && right == "R" do
#         {{r, c}, {r, c+1}}
#       else
#         nil
#       end
#     end |> Enum.reject(&is_nil/1)

#     v_pairs = for r <- 0..(rows-2), c <- 0..(cols-1) do
#       top = String.at(elem(board, r), c)
#       bottom = String.at(elem(board, r+1), c)
#       if top == "T" && bottom == "B" do
#         {{r, c}, {r+1, c}}
#       else
#         nil
#       end
#     end |> Enum.reject(&is_nil/1)

#     h_pairs ++ v_pairs
#   end

#   defp sort_pairs(pairs, specs, _rows, _cols) do
#     pairs
#     |> Enum.sort_by(fn {{r1, c1}, {r2, c2}} ->
#       s1 = score(specs["left"], r1) + score(specs["right"], r1)
#       s2 = score(specs["top"], c1) + score(specs["bottom"], c1)
#       s3 = score(specs["left"], r2) + score(specs["right"], r2)
#       s4 = score(specs["top"], c2) + score(specs["bottom"], c2)

#       -(s1 + s2 + s3 + s4)
#     end)
#   end

#   defp score(constraints, index) do
#     value = elem(constraints, index)
#     if value != -1, do: 2, else: 0
#   end

#   defp solve(_board, sol, [], state) do
#     if valid_sol?(state) do
#       {:ok, sol}
#     else
#       :error
#     end
#   end

#   defp solve(board, sol, [pair | rest], state) do
#     {{r1, c1}, {r2, c2}} = pair

#     options = [
#       {"+", "-"},
#       {"-", "+"},
#       {"X", "X"}
#     ]

#     try_opts(board, sol, pair, rest, state, options)
#   end

#   defp try_opts(_board, _sol, _pair, _rest, _state, []), do: :error
#   defp try_opts(board, sol, {p1, p2}, rest, state, [{v1, v2} | opts]) do
#     {r1, c1} = p1
#     {r2, c2} = p2

#     new_sol = sol |> set_val(r1, c1, v1) |> set_val(r2, c2, v2)
#     new_state = update_state(state, r1, c1, v1, r2, c2, v2)

#     if valid_part?(new_sol, new_state) do
#       case solve(board, new_sol, rest, new_state) do
#         {:ok, final} ->
#           {:ok, final}
#         _ ->
#           try_opts(board, sol, {p1, p2}, rest, state, opts)
#       end
#     else
#       try_opts(board, sol, {p1, p2}, rest, state, opts)
#     end
#   end

#   defp valid_part?(sol, state) do
#     valid_counts(state) && no_adj_same(sol)
#   end

#   defp set_val(sol, row, col, val) do
#     List.update_at(sol, row, fn r ->
#       List.replace_at(r, col, val)
#     end)
#   end

#   defp no_adj_same(sol) do
#     rows = length(sol)
#     cols = length(Enum.at(sol, 0))

#     h_ok = Enum.all?(0..(rows-1), fn r ->
#       row = Enum.at(sol, r)
#       Enum.all?(0..(cols-2), fn c ->
#         a = Enum.at(row, c)
#         b = Enum.at(row, c+1)
#         a == "X" || b == "X" || a != b
#       end)
#     end)

#     v_ok = Enum.all?(0..(rows-2), fn r ->
#       r1 = Enum.at(sol, r)
#       r2 = Enum.at(sol, r+1)
#       Enum.all?(0..(cols-1), fn c ->
#         a = Enum.at(r1, c)
#         b = Enum.at(r2, c)
#         a == "X" || b == "X" || a != b
#       end)
#     end)

#     h_ok && v_ok
#   end

#   defp valid_counts(state) do
#     check_list(state.plus_rows, state.left_constraints, false) &&
#     check_list(state.minus_rows, state.right_constraints, false) &&
#     check_list(state.plus_cols, state.top_constraints, false) &&
#     check_list(state.minus_cols, state.bottom_constraints, false)
#   end

#   defp check_list(counts, constraints, exact \\ true) do
#     0..(tuple_size(constraints) - 1)
#     |> Enum.all?(fn i ->
#       c = elem(constraints, i)
#       n = Enum.at(counts, i)
#       c == -1 || (exact && n == c) || (!exact && n <= c)
#     end)
#   end

#   defp valid_sol?(state) do
#     check_list(state.plus_rows, state.left_constraints) &&
#     check_list(state.minus_rows, state.right_constraints) &&
#     check_list(state.plus_cols, state.top_constraints) &&
#     check_list(state.minus_cols, state.bottom_constraints)
#   end

#   defp update_state(state, r1, c1, v1, r2, c2, v2) do
#     state
#     |> update_pos(r1, c1, v1)
#     |> update_pos(r2, c2, v2)
#   end

#   defp update_pos(state, _r, _c, "X"), do: state
#   defp update_pos(state, r, c, "+") do
#     %{
#       state |
#       plus_rows: List.update_at(state.plus_rows, r, &(&1 + 1)),
#       plus_cols: List.update_at(state.plus_cols, c, &(&1 + 1))
#     }
#   end
#   defp update_pos(state, r, c, "-") do
#     %{
#       state |
#       minus_rows: List.update_at(state.minus_rows, r, &(&1 + 1)),
#       minus_cols: List.update_at(state.minus_cols, c, &(&1 + 1))
#     }
#   end

#   defp to_string_sol(sol, rows) do
#     sol
#     |> Enum.map(&Enum.join/1)
#     |> List.to_tuple()
#   end
# end
