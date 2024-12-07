local DOPRINT = false
-- local DOPRINT = true

local function add(left, right) return left + right end
local function mul(left, right) return left * right end
local function con(left, right) return tonumber(tostring(left) .. tostring(right)) end

local OP_TO_FUN = {
    ["+"] = add,
    ["*"] = mul,
    ["|"] = con,
}

local function calc(sum, numbers, operators)
    assert(#numbers == #operators + 1)

    if DOPRINT then print("NUM: " .. table.concat(numbers, ",")) end
    if DOPRINT then print("OPS: " .. table.concat(operators, ",")) end

    local op_stack, num_stack = {}, {}
    for i = #operators, 1, -1 do table.insert(op_stack, operators[i]) end
    for i = #numbers, 1, -1 do table.insert(num_stack, numbers[i]) end

    if DOPRINT then print("COPS: " .. table.concat(op_stack, ",")) end
    if DOPRINT then print("CNUM: " .. table.concat(num_stack, ",")) end

    while #op_stack > 0 do
        local op = table.remove(op_stack)
        local right = table.remove(num_stack)
        local left = table.remove(num_stack)
        table.insert(num_stack, OP_TO_FUN[op](right, left))
    end
    assert(#num_stack == 1)

    if DOPRINT then print("SUM: " .. sum) end
    if DOPRINT then print("ACC: " .. num_stack[1]) end
    if DOPRINT then print("RES: " .. tostring(num_stack[1] == sum)) end

    return num_stack[1] == sum
end

local function check(sum, numbers, i, operators)
    if DOPRINT then print(sum .. ": " .. table.concat(numbers, ",") .. "[" .. tostring(i) .. "]") end

    if i == nil then i = 1; operators = {} end

    if i == #numbers then
        return calc(sum, numbers, operators)
    else
        table.insert(operators, "+")
        if check(sum, numbers, i + 1, operators) then return true end
        table.remove(operators)

        table.insert(operators, "*")
        if check(sum, numbers, i + 1, operators) then return true end
        table.remove(operators)

        table.insert(operators, "|")
        if check(sum, numbers, i + 1, operators) then return true end
        table.remove(operators)
    end

    return false
end

do
    -- assert(calc(6, {1, 2, 3}, {"+", "+"}))
    -- assert(calc(5, {1, 2, 3}, {"*", "+"}))
    -- assert(calc(12, {1, 2}, {"|"}))
    -- assert(calc(223, {1, 1, 2, 3}, {"+", "|", "|"}))
    -- assert(calc(7290, {6, 8, 6, 15}, {"*", "|", "*"}))
    -- assert(calc(15156126976,
    --             { 6, 3, 70, 9, 9, 3, 8, 4, 1, 9, 973, 3 },
    --             {"*","|","*","+","|","+","|","*","*","|","+"}))
end

do
    -- assert(check(11, { 1, 1 }))
    -- assert(not check(12, { 1, 10}))
    -- assert(check(10, { 1, 10}))
    -- assert(check(1, { 1 }))

    -- assert(check(10, { 1, 10}))
    -- assert(check(10, { 1, 0}))
    -- assert(check(10, { 9, 1}))
    -- assert(not check(21, { 9, 1}))

    -- assert(check(190, { 10, 19 }))
    -- assert(check(3267, { 81, 40, 27 }))
    -- assert(not check(83, { 17, 5 }))
    -- assert(check(156, { 15, 6 }))

    -- assert(check(7290, { 6, 8, 6, 15 }))

    -- assert(not check(161011, { 16, 10, 13 }))
    -- assert(check(192, { 17, 8, 14 }))
    -- assert(not check(21037, { 9, 7, 18, 13 }))
    -- assert(check(292, { 11, 6, 16, 20 }))

    -- print("test")
    -- assert( check(15156126976, { 6, 3, 70, 9, 9, 3, 8, 4, 1, 9, 973, 3 }) )
    -- assert( check(56083790, { 93, 7, 89, 932, 67, 58, 5 }) )
end

do
    local input = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        local sum, num_list = line:match("(%d+): ([%d%s]+)")
        local numbers = {}
        for num in num_list:gmatch("%d+") do
            table.insert(numbers, tonumber(num))
        end
        input[tonumber(sum)] = numbers
    end
    file:close()

    local result = 0
    for sum, numbers in pairs(input) do
        if check(sum, numbers) then
            result = result + sum
        end
    end
    print(result)
end
