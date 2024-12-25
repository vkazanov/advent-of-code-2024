local function check(sum, numbers, i)
    if i == nil then i = #numbers end

    local number = numbers[i]
    if i == 1 then
        if sum == number then return true end
        return false
    end

    if sum % number == 0 and check(sum // number, numbers, i - 1) then
        return true
    end

    if check(sum - number, numbers, i - 1) then
        return true
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
            table.insert(numbers, tonumber(num))
        end
        input[tonumber(sum)] = numbers
    end

    local result = 0
    for sum, numbers in pairs(input) do
        if check(sum, numbers) then result = result + sum end
    end

    assert(result == 5702958180383)
end
