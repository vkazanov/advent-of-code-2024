local file = io.open("input.txt", "r")

local safe_report_num = 0
local safe_diffs = {[1] = true, [2]=true,[3]=true}
for line in file:lines() do
    local it = line:gmatch("%d+")
    local prev_diff = 0
    local prev_num = tonumber(it())

    for num in it do
        local this_num = tonumber(num)
        local this_diff = prev_num - this_num

        -- diff within range
        if not safe_diffs[math.abs(this_diff)] then goto unsafe end

        -- not a same diff sign
        if this_diff * prev_diff < 0 then goto unsafe end

        prev_diff = this_diff
        prev_num = this_num
    end

    safe_report_num = safe_report_num + 1
    ::unsafe::
end

assert(safe_report_num == 660)
