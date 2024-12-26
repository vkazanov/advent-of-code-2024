local aoc = require"aoc"

local tins = table.insert

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

local function check(sum, numbers)
    for _, ops in ipairs(aoc.product_repeat(OPS, #numbers - 1)) do
        if calc(numbers, ops) == sum then return true end
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
