local aoc = require"aoc"

local tins = table.insert

local function add(left, right) return left + right end
local function mul(left, right) return left * right end
local function con(left, right) return tonumber(tostring(left) .. tostring(right)) end

local OPS = {add,mul,con,}

local function calc(sum, numbers, operators)
    local left = numbers[1]
    for i, op in ipairs(operators) do
        left = op(left, numbers[i + 1])
        if left > sum then return false end
    end
    return left == sum
end

local function check(sum, numbers, num_to_ops)
    for _, ops in ipairs(num_to_ops[#numbers]) do
        if calc(sum, numbers, ops) then return true end
    end
    return false
end

do
    local input = {}
    local num_to_ops = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        local sum, num_list = line:match("(%d+): ([%d%s]+)")
        local numbers = {}
        for num in num_list:gmatch("%d+") do
            tins(numbers, tonumber(num))
        end
        input[tonumber(sum)] = numbers
        if not num_to_ops[#numbers] then
            num_to_ops[#numbers] = aoc.product_repeat(OPS, #numbers - 1)
        end
    end

    local result = 0
    for sum, numbers in pairs(input) do
        if check(sum, numbers, num_to_ops) then
            result = result + sum
        end
    end
    assert(result == 92612386119138)
end
