-- Part 2

local file = io.open("input.txt", "r")

local left_arr, right_to_count = {}, {}
for line in file:lines() do
   local left_id, right_id = line:match("(%d+)%s+(%d+)")
   assert(left_id and right_id)

   left_id = tonumber(left_id)
   table.insert(left_arr, left_id)

   right_id = tonumber(right_id)
   right_to_count[right_id] = (right_to_count[right_id] or 0) + 1
end

local score = 0
for _, id in pairs(left_arr) do
   score = score + (right_to_count[id] or 0) * id
end
assert(score == 23177084)
