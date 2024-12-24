-- Part 1

local file = io.open("input.txt", "r")
if not file then
    print("Error: Could not open file!")
    return
end

local left_arr, right_arr = {}, {}
for line in file:lines() do
   local left_id, right_id = line:match("(%d+)%s+(%d+)")
   assert(left_id and right_id)
   left_id = tonumber(left_id)
   right_id = tonumber(right_id)
   table.insert(left_arr, left_id)
   table.insert(right_arr, right_id)
end

file:close()

assert(#left_arr == #right_arr)

table.sort(left_arr)
table.sort(right_arr)

local total_diff = 0
for i = 1, #left_arr do
   total_diff = total_diff + math.abs(left_arr[i] - right_arr[i])
end

assert(total_diff == 2057374)
