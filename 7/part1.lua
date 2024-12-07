local DOPRINT = false

local function check(sum, numbers, i)
    -- TODO: check that division is correct
    -- TODO: check the base case
    if i == nil then i = #numbers end
    if DOPRINT then print(sum .. ": " .. table.concat(numbers, ",") .. "[" .. i .. "]") end

    local number = numbers[i]
    if i == 1 then
        if sum == number then
            if DOPRINT then print(i .. "done") end
            return true
        end

        if sum - number == 0 then
            if DOPRINT then print(i .. "done") end
            return true
        end

        return false
    end

    local next_i = i - 1
    -- check the division case
    if sum % number == 0 and check(sum // number, numbers, next_i) then
        if DOPRINT then print(i .. "div") end
        return true
    end

    if check(sum - number, numbers, next_i) then
        if DOPRINT then print(i .. "add") end
        return true
    end

    return false
end


do
    assert(check(190, { 10, 19 }))
    assert(check(3267, { 81, 40, 27 }))
    assert(not check(83, { 17, 5 }))
    assert(not check(156, { 15, 6 }))
    assert(not check(7290, { 6, 8, 6, 15 }))
    assert(not check(161011, { 16, 10, 13 }))
    assert(not check(192, { 17, 8, 14 }))
    assert(not check(21037, { 9, 7, 18, 13 }))
    assert(check(292, { 11, 6, 16, 20 }))
end

do
    local input = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        -- print(line)
        local sum, num_list = line:match("(%d+): ([%d%s]+)")
        local numbers = {}
        for num in num_list:gmatch("%d+") do
            table.insert(numbers, tonumber(num))
        end
        print(sum .. ": " .. table.concat(numbers, ","))
        input[sum] = numbers
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
