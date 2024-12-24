local tins = table.insert

local function key(this, that)
    return this .. "|" .. that
end

local function check(rules, update)
    for i, this in pairs(update) do
        for j, that in pairs(update) do
            if i < j and rules[key(that, this)] then
                return false
            elseif i > j and rules[key(this, that)] then
                return false
            end
        end
    end

    return true
end

local function fix(rules, update)
    table.sort(
        update,
        function(this, that)
            return rules[key(this, that)]
        end
    )
end

local file = io.open("input.txt", "r")

local rules = {}
for line in file:lines() do
    if line == "" then break end
    rules[line] = true
end

local correct_num = 0
local fixed_num = 0
for line in file:lines() do
    local update = {}
    for page in line:gmatch("%d+") do
        tins(update, tonumber(page))
    end

    if check(rules, update) then
        correct_num = correct_num + update[#update // 2 + 1]

    else
        fix(rules, update)
        fixed_num = fixed_num + update[#update // 2 + 1]
    end

end

assert(correct_num == 5248)
assert(fixed_num == 4507)
