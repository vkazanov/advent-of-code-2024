local file = io.open("input.txt", "r")
if not file then
    print("Error: Could not open file!")
    return
end

local safe_report_num = 0
for line in file:lines() do
    print(line)
    it = line:gmatch("%d+")
    local prev_diff = 0
    local prev_num = tonumber(it())
    print("First num: ", prev_num)
    local is_safe = true

    for num in it do
        local this_num = tonumber(num)
        local this_diff = prev_num - this_num
        print("Num: ", this_num, "Diff: ", this_diff)

        -- diff within range
        if math.abs(this_diff) == 0 or math.abs(this_diff) > 3 then
            print("NOT within range")
            is_safe = false
            break
        end
        print("within range")

        -- same diff sign if there is a diff defined
        if not (prev_diff == 0) then
            is_safe = (this_diff > 0 and prev_diff > 0) or
                (this_diff < 0 and prev_diff < 0)
        end
        if not is_safe then
            print("NOT same diff")
            break
        end
        print("diff same")

        prev_diff = this_diff
        prev_num = this_num
    end
    print("safe", is_safe)

    -- check if we broke out of the loop
    if is_safe == true then
        safe_report_num = safe_report_num + 1
    end
end

print("Safe: ", safe_report_num)

file:close()
