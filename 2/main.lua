Part2 = require("part2")

local file = io.open("input.txt", "r")
if not file then
    print("Error: Could not open file!")
    return
end

local safe_report_num = 0
for line in file:lines() do

    local report = Part2.parse_report(line)
    if Part2.is_dampened_safe(report) then
        safe_report_num = safe_report_num + 1
    end
end

print("Safe report num: ", safe_report_num)

file:close()
