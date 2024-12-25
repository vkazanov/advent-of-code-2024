local tins = table.insert
local trem = table.remove

local function add(left, right) return left + right end
local function mul(left, right) return left * right end
local function con(left, right) return tonumber(tostring(left) .. tostring(right)) end

local OPS = {add,mul,con,}

local function calc(numbers, operators)
    assert(#numbers == #operators + 1)

    local left = numbers[1]
    for i, op in ipairs(operators) do
        left = op(left, numbers[i + 1])
    end

    return left
end

local function check(sum, numbers, operators)
    if #operators + 1 == #numbers then return calc(numbers, operators) == sum end

    for _, op in pairs(OPS) do
        tins(operators, op)
        if check(sum, numbers, operators) then return true end
        trem(operators)
    end

    return false
end

do
    local input = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        local sum, num_list = line:match("(%d+): ([%d%s]+)")
        local numbers = {}
        for num in num_list:gmatch("%d+") do
            tins(numbers, tonumber(num))
        end
        input[tonumber(sum)] = numbers
    end

    local result = 0
    for sum, numbers in pairs(input) do
        if check(sum, numbers, {}) then result = result + sum end
    end
    assert(result == 92612386119138)
end
