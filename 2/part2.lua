local Part2 = {}

local VALID_DIFF <const> = { [1] = true, [2] = true, [3] = true }
function Part2.is_safe(report)
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

function Part2.is_dampened_safe(report)
    -- find a safe report, also skip an element when checking if necessary (note i = 0)
    for i = 0, #report do
        -- build a dumpened report
        local subreport = {}
        for j = 1, #report do
            if i ~= j then
                table.insert(subreport, report[j])
            end
        end

        if Part2.is_safe(subreport) then
            return true
        end
    end

    return false
end

function Part2.parse_report(line)
    local report = {}
    for level in line:gmatch("%d+") do
        table.insert(report, tonumber(level))
    end
    return report
end

return Part2
