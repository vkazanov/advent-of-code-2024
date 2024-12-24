local tins = table.insert

local function fix(rules, update)
    table.sort(
        update,
        function(this, that)
            return rules[this .. "|" .. that]
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

    local orig, fixed = {}, {}
    for page in line:gmatch("%d+") do
        tins(orig, tonumber(page))
        tins(fixed, tonumber(page))
    end

    -- fix and see if anything was updated
    fix(rules, fixed)
    for k, v in ipairs(orig) do
        if v ~= fixed[k] then
            fixed_num = fixed_num + fixed[#fixed // 2 + 1]
            goto fixed
        end
    end
    correct_num = correct_num + orig[#orig // 2 + 1]

    ::fixed::
end

assert(correct_num == 5248)
assert(fixed_num == 4507)
