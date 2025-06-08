

# defmodule Polarity do

#   @moduledoc """
#     Add your solver function below. You may add additional helper functions if you desire.
#     Test your code by running 'mix test --seed 0' from the simple_tester_ex directory.
#   """

#   def polarity(board, specs) do
#     grid = Tuple.to_list(board) |> Enum.map(&String.graphemes/1)
#     # IO.puts(done(grid, specs))
#     solve(grid, specs, 0, 0)

#   end

#   def solve(grid, specs, row, col) do

#     IO.inspect(checkConstraints(grid, specs))
#     printStuff(grid, row, col)

#     cond do
#       (done(grid, specs)) -> IO.puts("DONEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
#       (checkConstraints(grid, specs)) -> IO.puts("BACKTRACE")
#       (col == 0 and row == length(grid)) -> IO.inspect(grid)
#                                             IO.puts("PRINTING GRID")

#       (col >= length(Enum.at(grid, 0))) ->  IO.puts("NEXT ROW")
#                                             solve(grid, specs, row+1, 0)


#       true ->

#         cond do
#           (access_at(grid, row, col) == "L") ->

#           if (placeHorizontal?(grid, specs, row, col, "+-")) do
#             grid = update_value(grid, row, col, "+")
#             grid = update_value(grid, row, col+1, "-")

#             solve(grid, specs, row, col + 2)

#             # grid = update_value(grid, row, col, "L")
#             # grid = update_value(grid, row, col+1, "R")
#           end

#           if (placeHorizontal?(grid, specs, row, col, "-+")) do
#             grid = update_value(grid, row, col, "-")
#             grid = update_value(grid, row, col+1, "+")

#             solve(grid, specs, row, col + 2)

#             # grid = update_value(grid, row, col, "L")
#             # grid = update_value(grid, row, col+1, "R")
#           end


#           (access_at(grid, row, col) == "T") ->

#             if(placeVertical?(grid, specs, row, col, "+-")) do
#               grid = update_value(grid, row, col, "+")
#               grid = update_value(grid, row+1, col, "-")

#               solve(grid, specs, row, col + 1)

#               # grid = update_value(grid, row, col, "T")
#               # grid = update_value(grid, row+1, col, "B")
#             end

#             if(placeVertical?(grid, specs, row, col, "-+")) do
#               grid = update_value(grid, row, col, "-")
#               grid = update_value(grid, row+1, col, "+")

#               solve(grid, specs, row, col + 1)

#               # grid = update_value(grid, row, col, "T")
#               # grid = update_value(grid, row+1, col, "B")
#             end

#             solve(grid, specs, row, col+1)

#           true -> solve(grid, specs, row, col+1)
#         end
#       end
#     end

















































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

#   def done(grid, specs) do
#     %{"left" => left_s, "right" => right_s, "top" => top_s, "bottom" => bottom_s} = specs
#     [left_s, right_s, top_s, bottom_s] = [left_s, right_s, top_s, bottom_s] |> Enum.map(&Tuple.to_list/1)
#     left = Enum.map(grid, fn row -> Enum.count(row, fn x -> x == "+" end) end)
#     right = Enum.map(grid, fn row -> Enum.count(row, fn x -> x == "-" end) end)
#     top = grid |> Enum.zip() |> Enum.map(fn col -> Enum.count(Tuple.to_list(col), &(&1 == "+")) end)
#     bottom = grid |> Enum.zip() |> Enum.map(fn col -> Enum.count(Tuple.to_list(col), &(&1 == "-")) end)

#     temp_grid = [left, right, bottom, top]
#     specs_grid = [left_s, right_s, bottom_s, top_s]

#     # Check if all specified constraints have been met exactly
#     Enum.zip(temp_grid, specs_grid)
#     |> Enum.all?(fn {temp_row, spec_row} ->
#       Enum.zip(temp_row, spec_row)
#       |> Enum.all?(fn {temp_val, spec_val} ->
#         spec_val == -1 || temp_val == spec_val
#       end)
#     end)
#   end


#   def placeHorizontal?(grid, specs, row, col, magnet) do

#     cond do
#       (col - 1 >= 0 and access_at(grid, row, col - 1) == String.at(magnet, 0)) -> false
#       (row - 1 >= 0 and access_at(grid, row - 1, col) == String.at(magnet, 0)) -> false
#       (row - 1 >= 0 and access_at(grid, row - 1, col + 1) == String.at(magnet, 1)) -> false
#       (col + 2 < length(Enum.at(grid, 0)) and access_at(grid, row, col + 2) == String.at(magnet, 1)) -> false
#       true -> true
#     end
#   end

#   def placeVertical?(grid, specs, row, col, magnet) do

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
#   def printStuff(grid, row, col) do
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
# board2 = {"+-+-x-", "-+-+x+", "xx+-+-", "xx-+x+", "-+xxx-"}
# specs = %{ "left" => {2, 3, -1, -1, -1},
#            "right" => {-1, -1, -1, 1, -1},
#            "top" => {1, -1, -1, 2, 1, -1},
#            "bottom" => {2, -1, -1, 2, -1, 3}
#          }
# Polarity.polarity(board, specs)











# NEW


# defmodule Polarity do

#   @moduledoc """
#     Add your solver function below. You may add additional helper functions if you desire.
#     Test your code by running 'mix test --seed 0' from the simple_tester_ex directory.
#   """

#   def polarity(board, specs) do
#     grid = Tuple.to_list(board) |> Enum.map(&String.graphemes/1)
#     # IO.puts(done(grid, specs))
#     IO.puts(solve(grid, 0, 0, specs))

#   end

#   # TO DO -> Potential Fix
#   # Add a list or another paaramters saying it cant go that way

#   # Done
#   def solve(grid, row, col, specs) when row >= length(grid), do: "Not Possible"


#   # Next Row
#   def solve([first_row | _] = grid, row, col, specs) when col >= length(first_row) do
#     Process.sleep(1000)
#     # IO.write("\e[H\e[2J")
#     printStuff("NEXT ROW", grid, row, col)
#     solve(grid, row+1, 0, specs)

#   end

#   # Forward
#   def solve(grid, row, col, specs) do
#     Process.sleep(1000)
#     # IO.write("\e[H\e[2J")

#     if (checkConstraints(grid, specs)) do
#       printStuff("BACKTRACK", grid, row, col)
#       "BACKTRACK"

#     else
#       printStuff("FORWARD", grid, row, col)

#       cond do
#         (access_at(grid, row, col) == "L") ->

#           if (placeHorizontal?(grid, row, col, "+-")) do
#             grid = update_value(grid, row, col, "+")
#             grid = update_value(grid, row, col+1, "-")
#             message = solve(grid, row, col+2,specs)

#             if (message == "BACKTRACK") do
#               grid = update_value(grid, row, col, "L")
#               grid = update_value(grid, row, col+1, "R")
#             end
#           end

#           if (placeHorizontal?(grid, row, col, "-+")) do
#             grid = update_value(grid, row, col, "-")
#             grid = update_value(grid, row, col+1, "+")
#             message = solve(grid, row, col+2,specs)

#             if (message == "BACKTRACK") do
#               grid = update_value(grid, row, col, "X")
#               grid = update_value(grid, row, col+1, "X")
#               solve(grid, row, col+2, specs)
#             end
#           else
#             grid = update_value(grid, row, col, "X")
#             grid = update_value(grid, row, col+1, "X")
#             solve(grid, row, col+1, specs)
#           end

#         (access_at(grid, row, col) == "T") ->

#           if (placeVertical?(grid, row, col, "+-")) do
#             grid = update_value(grid, row, col, "+")
#             grid = update_value(grid, row+1, col, "-")
#             message = solve(grid, row, col+1, specs)

#             if (message == "BACKTRACK") do
#               grid = update_value(grid, row, col, "T")
#               grid = update_value(grid, row+1, col, "B")
#             end
#           end

#           if (placeVertical?(grid, row, col, "-+")) do
#               grid = update_value(grid, row, col, "-")
#               grid = update_value(grid, row+1, col, "+")
#               message = solve(grid, row, col+1, specs)

#               if (message == "BACKTRACK") do
#                 grid = update_value(grid, row, col, "X")
#                 grid = update_value(grid, row+1, col, "X")
#                 solve(grid, row, col+1, specs)
#               end
#           else
#             grid = update_value(grid, row, col, "X")
#             grid = update_value(grid, row+1, col, "X")
#             solve(grid, row, col+1, specs)
#           end


#         true ->  solve(grid, row, col+1, specs)
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
#   def printStuff(func, grid, row, col) do
#     IO.puts(func)
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
