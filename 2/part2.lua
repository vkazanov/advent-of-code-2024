local file = io.open("input.txt", "r")
if not file then
    print("Error: Could not open file!")
    return
end

local VALID_DIFF = {[1] = true, [2] = true, [3] = true}
local function is_safe(report)
    local prev_diff = nil

    for i = 2, #report do
        local this_diff = report[i] - report[i-1]

        -- correct level diff
        if not VALID_DIFF[math.abs(this_diff)] then
            return false
        end

        -- same diff sign if there is a diff defined
        if prev_diff ~= nil and this_diff * prev_diff < 0 then
            return false
        end

        prev_diff = this_diff
    end

    return true
end

local safe_report_num = 0
for line in file:lines() do

    -- parse input lines
    local report = {}
    for level in line:gmatch("%d+") do
        table.insert(report, tonumber(level))
    end

    -- find a safe report, also skip an element when checking if necessary (note i = 0)
    for i = 0, #report do
        -- build a dumpened report
        local subreport = {}
        for j = 1, #report do
            if i ~= j then
                table.insert(subreport, report[j])
            end
        end

        -- check if it is ok
        if is_safe(subreport) then
            safe_report_num = safe_report_num + 1
            goto next_report
        end
    end

    ::next_report::
end

print("Safe report num: ", safe_report_num)
file:close()
