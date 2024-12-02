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
   print(left_id, "   ", right_id)
   table.insert(left_arr, left_id)
   table.insert(right_arr, right_id)
end

file:close()

print("Left = ", #left_arr, "Right = ", #right_arr)
assert(#left_arr == #right_arr)

table.sort(left_arr)
table.sort(right_arr)

for i, value in ipairs(left_arr) do
    print(left_arr[i], "   ", right_arr[i])
end

local total_diff = 0
for i = 1, #left_arr, 1 do
   total_diff = total_diff + math.abs(left_arr[i] - right_arr[i])
end

print("Total diff = ", total_diff)
