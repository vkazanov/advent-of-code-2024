-- Part 2

-- local file = io.open("input_test.txt", "r")
local file = io.open("input.txt", "r")
if not file then
   print("Error: Could not open file!")
   return
end

local function is_safe(report)
   local prev_diff = 0
   local prev_num = report[1]
   local is_safe = true

   for i = 2, #report do
      local this_num = report[i]
      local this_diff = prev_num - this_num

      -- diff within range
      if math.abs(this_diff) == 0 or math.abs(this_diff) > 3 then
         is_safe = false
         break
      end

      -- same diff sign if there is a diff defined
      if not (prev_diff == 0) then
         is_safe = (this_diff > 0 and prev_diff > 0) or
            (this_diff < 0 and prev_diff < 0)
      end
      if not is_safe then
         break
      end

      prev_diff = this_diff
      prev_num = this_num
   end

   print(table.concat(report, " "), " -> ", is_safe)

   return is_safe
end

local safe_report_num = 0
for line in file:lines() do
   local report = {}
    for num in line:gmatch("%d+") do
        table.insert(report, tonumber(num))
    end

    -- check if a full report is safe
    if is_safe(report) then
       safe_report_num = safe_report_num + 1
       goto continue
    end

    -- look for an element to skip to make the report safe
    for i, num in ipairs(report) do
       local subreport = {}
       for j, subnum in ipairs(report) do
          if not (i == j) then
             table.insert(subreport, subnum)
          end
       end
       if is_safe(subreport) then
          safe_report_num = safe_report_num + 1
          goto continue
       end
    end

    ::continue::
    print()
end

print("Safe report num: ", safe_report_num)

file:close()
