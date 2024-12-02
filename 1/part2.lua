-- Part 2

-- local file = io.open("test_input.txt", "r")
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
   table.insert(left_arr, left_id)

   right_id = tonumber(right_id)
   right_arr[right_id] = (right_arr[right_id] or 0) + 1
   print(left_id, "   ", right_id)
end

file:close()

local score = 0
for _, id in pairs(left_arr) do
   if right_arr[id] then
      print(id, " -> ", right_arr[id])
   end
   score = score + (right_arr[id] or 0) * id
end
print("Score: ", score)
