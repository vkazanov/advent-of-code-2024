local tins = table.insert

local function check(rules, update)
    local rules_map = {}
    for _, rule_str in pairs(rules) do
        rules_map[rule_str] = true
    end

    for i, this in pairs(update) do
        for j, that in pairs(update) do
            if i < j then
                if rules_map[that .. "|" .. this] then
                    return false
                end
            elseif i > j then
                if rules_map[this .. "|" .. that] then
                    return false
                end
            end
        end
    end

    return true, update[#update // 2 + 1]
end

local function fix(rules, update)
    local rules_map = {}
    for _, rule_str in pairs(rules) do
        rules_map[rule_str] = true
    end

    local fixed_update = {}
    for _, v in pairs(update) do tins(fixed_update, v) end

    for i, this in pairs(fixed_update) do
        for j, that in pairs(fixed_update) do
            if i < j then
                if rules_map[that .. "|" .. this] then
                    fixed_update[i] = that
                    fixed_update[j] = this
                    goto fixed
                end
            elseif i > j then
                if rules_map[this .. "|" .. that] then
                    fixed_update[j] = that
                    fixed_update[i] = this
                    goto fixed
                end
            end
        end
    end

    ::fixed::
    return fixed_update
end

local rules = {}
local file = io.open("input.txt", "r")

for line in file:lines() do
    if line == "" then break end
    tins(rules, line)
end
assert(#rules == 1176)

local count_correct = 0
local count_fixed = 0
for line in file:lines() do
    local update = {}
    for page in line:gmatch("%d+") do
        tins(update, tonumber(page))
    end
    assert(#update % 2 == 1)

    local is_correct, mid = check(rules, update)
    if is_correct then
        count_correct = count_correct + mid

    else
        local fixed_update = update
        repeat
            fixed_update = fix(rules, fixed_update)
            is_correct, mid = check(rules, fixed_update)
        until is_correct

        count_fixed = count_fixed + mid
    end

end

assert(count_correct == 5248)
assert(count_fixed == 4507)
