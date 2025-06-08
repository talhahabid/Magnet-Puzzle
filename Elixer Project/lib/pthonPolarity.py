# defmodule Polarity do
#   def main do
    # board = {
    #   "LRLRTT",
    #   "LRLRBB",
    #   "TTTTLR",
    #   "BBBBTT",
    #   "LRLRBB"
    # }

    # specs = %{
    #   "left" => {2, 3, -1, -1, -1},
    #   "right" => {-1, -1, -1, 1, -1},
    #   "top" => {1, -1, -1, 2, 1, -1},
    #   "bottom" => {2, -1, -1, 2, -1, 3}
    # }

#     grid = board |> Tuple.to_list() |> Enum.map(&String.graphemes/1)
#     solve(grid, specs) |> print_result()
#   end

#   defp solve(grid, specs) do
#     do_solve(grid, 0, 0, specs)
#   end

#   defp do_solve(grid, row, col, specs) when row >= length(grid) do
#     if check_constraints(grid, specs), do: grid, else: nil
#   end

#   defp do_solve(grid, row, col, specs) do
#     current_row = Enum.at(grid, row)
#     cond do
#       col >= length(current_row) ->
#         do_solve(grid, row + 1, 0, specs)
#       true ->
#         cell = Enum.at(current_row, col)
#         cond do
#           cell in ["+", "-", "x", "R", "B"] ->
#             do_solve(grid, row, col + 1, specs)
#           cell == "L" ->
#             try_horizontal(grid, row, col, specs)
#           cell == "T" ->
#             try_vertical(grid, row, col, specs)
#           true ->
#             do_solve(grid, row, col + 1, specs)
#         end
#     end
#   end

#   defp try_horizontal(grid, row, col, specs) do
#     if col + 1 >= length(Enum.at(grid, row)) || Enum.at(Enum.at(grid, row), col + 1) != "R" do
#       nil
#     else
#       ["+-", "-+", "xx"]
#       |> Enum.reduce_while(nil, fn pattern, acc ->
#         new_grid = case pattern do
#           "xx" ->
#             grid
#             |> update(row, col, "x")
#             |> update(row, col + 1, "x")
#           _ ->
#             if can_place_horizontal?(grid, row, col, pattern) do
#               grid
#               |> update(row, col, String.at(pattern, 0))
#               |> update(row, col + 1, String.at(pattern, 1))
#             end
#         end
#         if new_grid, do: check_next(new_grid, row, col + 2, specs), else: {:cont, acc}
#       end)
#     end
#   end

#   defp try_vertical(grid, row, col, specs) do
#     if row + 1 >= length(grid) || Enum.at(Enum.at(grid, row + 1), col) != "B" do
#       nil
#     else
#       ["+-", "-+", "xx"]
#       |> Enum.reduce_while(nil, fn pattern, acc ->
#         new_grid = case pattern do
#           "xx" ->
#             grid
#             |> update(row, col, "x")
#             |> update(row + 1, col, "x")
#           _ ->
#             if can_place_vertical?(grid, row, col, pattern) do
#               grid
#               |> update(row, col, String.at(pattern, 0))
#               |> update(row + 1, col, String.at(pattern, 1))
#             end
#         end
#         if new_grid, do: check_next(new_grid, row, col + 1, specs), else: {:cont, acc}
#       end)
#     end
#   end

#   defp check_next(grid, row, col, specs) do
#     case do_solve(grid, row, col, specs) do
#       nil -> {:cont, nil}
#       solution -> {:halt, solution}
#     end
#   end

#   defp check_constraints(grid, specs) do
#     %{"left" => l, "right" => r, "top" => t, "bottom" => b} = specs
#     left = Enum.map(grid, &Enum.count(&1, fn c -> c == "+" end))
#     right = Enum.map(grid, &Enum.count(&1, fn c -> c == "-" end))

#     columns = Enum.zip(grid) |> Enum.map(fn col -> Tuple.to_list(col) end)
#     top = Enum.map(columns, &Enum.count(&1, fn c -> c == "+" end))
#     bottom = Enum.map(columns, &Enum.count(&1, fn c -> c == "-" end))

#     check_side(left, Tuple.to_list(l)) &&
#     check_side(right, Tuple.to_list(r)) &&
#     check_side(top, Tuple.to_list(t)) &&
#     check_side(bottom, Tuple.to_list(b))
#   end

#   defp check_side(values, constraints) do
#     Enum.zip(values, constraints)
#     |> Enum.all?(fn {v, c} -> c == -1 || v == c end)
#   end

#   defp can_place_horizontal?(grid, row, col, pattern) do
#     left = if col > 0, do: get(grid, row, col - 1), else: nil
#     above_left = if row > 0, do: get(grid, row - 1, col), else: nil
#     above_right = if row > 0 and col + 1 < length(Enum.at(grid, row)), do: get(grid, row - 1, col + 1), else: nil
#     right = if col + 2 < length(Enum.at(grid, row)), do: get(grid, row, col + 2), else: nil

#     [String.at(pattern, 0), String.at(pattern, 1)] != [left, right] &&
#     String.at(pattern, 0) != above_left &&
#     String.at(pattern, 1) != above_right
#   end

#   defp can_place_vertical?(grid, row, col, pattern) do
#     above = if row > 0, do: get(grid, row - 1, col), else: nil
#     left = if col > 0, do: get(grid, row, col - 1), else: nil
#     right = if col < length(Enum.at(grid, row)) - 1, do: get(grid, row, col + 1), else: nil

#     String.at(pattern, 0) != above &&
#     String.at(pattern, 0) != left &&
#     String.at(pattern, 0) != right
#   end

#   defp get(grid, row, col), do: Enum.at(Enum.at(grid, row), col)
#   defp update(grid, row, col, value), do: List.update_at(grid, row, &List.replace_at(&1, col, value))

#   defp print_result(nil), do: IO.puts("No solution found")
#   defp print_result(grid) do
#     grid
#     |> Enum.map(&Enum.join/1)
#     |> List.to_tuple()
#     |> IO.inspect()
#   end
# end

# Polarity.main()




# NEW
# defmodule Polarity do

#   @moduledoc """
#     Add your solver function below. You may add additional helper functions if you desire.
#     Test your code by running 'mix test --seed 0' from the simple_tester_ex directory.
#   """

#   def polarity(board, specs) do
#     grid = Tuple.to_list(board) |> Enum.map(&String.graphemes/1)
#     # IO.puts(done(grid, specs))
#     IO.puts(solve(grid, 0, 0, specs, 0))

#   end

#   # TO DO -> Potential Fix
#   # Add a list or another paaramters saying it cant go that way

#   # Done
#   def solve(grid, row, col, specs, stack) when row >= length(grid), do: "Not Possible"


#   # Next Row
#   def solve([first_row | _] = grid, row, col, specs, stack) when col >= length(first_row) do
#     # Process.sleep(1500)
#     # IO.write("\e[H\e[2J")
#     printStuff("NEXT ROW", grid, row, col, stack)
#     solve(grid, row+1, 0, specs, stack + 1)

#   end

#   def solve(grid, row, col, specs, stack) do
#     # Process.sleep(1500)
#     # IO.write("\e[H\e[2J")

#     if checkConstraints(grid, specs) do
#       printStuff("BACKTRACK", grid, row, col, stack)
#       "BACKTRACK"
#     else
#       printStuff("FORWARD", grid, row, col, stack)

#       cond do
#         access_at(grid, row, col) == "L" ->
#           # Horizontal cell handling
#           backtrack = false

#           if placeHorizontal?(grid, row, col, "+-") do
#             grid = update_value(grid, row, col, "+")
#             grid = update_value(grid, row, col+1, "-")
#             message = solve(grid, row, col+2, specs, stack + 1)

#             if message == "BACKTRACK" do
#               grid = update_value(grid, row, col, "L")
#               grid = update_value(grid, row, col+1, "R")
#               backtrack = true
#             end
#           end

#           if placeHorizontal?(grid, row, col, "-+") do
#             grid = update_value(grid, row, col, "-")
#             grid = update_value(grid, row, col+1, "+")
#             message = solve(grid, row, col+2, specs, stack + 1)

#             if message == "BACKTRACK" do
#               grid = update_value(grid, row, col, "L")  # Reset to L
#               grid = update_value(grid, row, col+1, "R") # Reset to R
#               backtrack = true
#             end
#           end

#           if backtrack do
#             "BACKTRACK"
#           else
#             grid = update_value(grid, row, col, "X")
#             grid = update_value(grid, row, col+1, "X")
#             solve(grid, row, col+2, specs, stack + 1)
#           end

#         access_at(grid, row, col) == "T" ->
#           # Vertical cell handling
#           backtrack = false

#           if placeVertical?(grid, row, col, "+-") do
#             grid = update_value(grid, row, col, "+")
#             grid = update_value(grid, row+1, col, "-")
#             message = solve(grid, row, col+1, specs, stack + 1)

#             if message == "BACKTRACK" do
#               grid = update_value(grid, row, col, "T")
#               grid = update_value(grid, row+1, col, "B")
#               backtrack = true
#             end
#           end

#           if placeVertical?(grid, row, col, "-+") do
#             grid = update_value(grid, row, col, "-")
#             grid = update_value(grid, row+1, col, "+")
#             message = solve(grid, row, col+1, specs, stack + 1)

#             if message == "BACKTRACK" do
#               grid = update_value(grid, row, col, "T")  # Reset to T
#               grid = update_value(grid, row+1, col, "B") # Reset to B
#               backtrack = true
#             end
#           end

#           if backtrack do
#             "BACKTRACK"
#           else
#             grid = update_value(grid, row, col, "X")
#             grid = update_value(grid, row+1, col, "X")
#             solve(grid, row, col+1, specs, stack + 1)
#           end

#         true ->
#           solve(grid, row, col+1, specs, stack + 1)
#       end
#     end
#   end











#   def checkConstraints(grid, specs) do

#     %{"left" => left_s, "right" => right_s, "top" => top_s, "bottom" => bottom_s} = specs
#     [left_s, right_s, top_s, bottom_s] = [left_s, right_s, top_s, bottom_s] |> Enum.map(&Tuple.to_list/1)
#     left = Enum.map(grid, fn row -> Enum.count(row, fn x -> x == "+" end) end)
#     right = Enum.map(grid, fn row -> Enum.count(row, fn x -> x == "-" end) end)
#     top = grid |> Enum.zip() |> Enum.map(fn col -> Enum.count(Tuple.to_list(col), &(&1 == "+")) end)
#     bottom = grid |> Enum.zip() |> Enum.map(fn col -> Enum.count(Tuple.to_list(col), &(&1 == "-")) end)

#     temp_grid = [left, right, bottom, top]
#     specs_grid = [left_s, right_s, bottom_s, top_s]

#     # IO.inspect(grid)
#     # IO.inspect(temp_grid)
#     # IO.inspect(specs_grid)

#     Enum.zip(temp_grid, specs_grid)
#     |> Enum.any?(fn {temp_row, spec_row} ->
#       Enum.zip(temp_row, spec_row)
#       |> Enum.any?(fn {temp_val, spec_val} ->
#         if spec_val != -1 and temp_val > spec_val do
#           # IO.puts("Mismatch: temp_val=#{temp_val}, spec_val=#{spec_val}")
#           true
#         else
#           false
#         end
#       end)
#     end)
#   end


#   def placeHorizontal?(grid, row, col, magnet) do

#     cond do
#       (col - 1 >= 0 and access_at(grid, row, col - 1) == String.at(magnet, 0)) -> false
#       (row - 1 >= 0 and access_at(grid, row - 1, col) == String.at(magnet, 0)) -> false
#       (row - 1 >= 0 and access_at(grid, row - 1, col + 1) == String.at(magnet, 1)) -> false
#       (col + 2 < length(Enum.at(grid, 0)) and access_at(grid, row, col + 2) == String.at(magnet, 1)) -> false
#       true -> true
#     end
#   end

#   def placeVertical?(grid, row, col, magnet) do

#     cond do
#       (col - 1 >= 0 and access_at(grid, row, col - 1) == String.at(magnet, 0)) -> false
#       (row - 1 >= 0 and access_at(grid, row - 1, col) == String.at(magnet, 0)) -> false
#       (col + 1 < length(Enum.at(grid, 0)) and access_at(grid, row, col + 1) == String.at(magnet, 0)) -> false
#       true -> true
#     end
#   end

#   # Helper Functions
#   def access_at(grid, row, col), do: Enum.at(Enum.at(grid, row), col)
#   def update_value(grid, row, col, value), do: List.update_at(grid, row, fn r -> List.update_at(r, col, fn _ -> value end) end)
#   def printStuff(func, grid, row, col, stack) do
#     IO.puts(func)
#     IO.puts("STACK: #{stack}")
#     IO.puts("GRID:")
#     Enum.each(grid, fn row -> IO.inspect(row) end)
#     IO.inspect("row: #{row}")
#     IO.inspect("col: #{col}")
#     IO.puts("________________________________________")
#     IO.puts("")
#   end
# end




# #__________________________________________________________________________________________#
# board = { "LRLRTT", "LRLRBB", "TTTTLR", "BBBBTT", "LRLRBB" }
# # board2 = {"+-+-x-", "-+-+x+", "xx+-+-", "xx-+x+", "-+xxx-"}
# # board = { "TTLR", "BBLR", "LRTT", "LRBB" }
# # specs = %{ "left"=>{0, 1, 2, -1},
# #         "right"=>{0, -1, 1, 2},
# #         "top"=>{1, 1, -1, 1},
# #         "bottom"=>{1, 1, 0, 2}
# #       }

# specs = %{ "left" => {2, 3, -1, -1, -1},
#            "right" => {-1, -1, -1, 1, -1},
#            "top" => {1, -1, -1, 2, 1, -1},
#            "bottom" => {2, -1, -1, 2, -1, 3}
#          }



# Polarity.polarity(board, specs)
