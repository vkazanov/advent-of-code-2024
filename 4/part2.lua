local P2 = {}

P2.pattern1 = {
    { [1] = "M", [3] = "S" },
    { [2] = "A"},
    { [1] = "M", [3] = "S" },
}

P2.pattern2 = {
    { [1] = "M", [3] = "M" },
    { [2] = "A"},
    { [1] = "S", [3] = "S" },
}

P2.pattern3 = {
    { [1] = "S", [3] = "S" },
    { [2] = "A"},
    { [1] = "M", [3] = "M" },
}

P2.pattern4 = {
    { [1] = "S", [3] = "M" },
    { [2] = "A"},
    { [1] = "S", [3] = "M" },
}

function P2.flatten(input)
    local width = #input[1]
    local flat = table.concat(input)
    return width, flat
end

function P2.flatten_pattern(pattern, offset)
    local flat_pattern = {}
    local line_offset = 0

    for _, line in pairs(pattern) do
        for j, char in pairs(line) do
            flat_pattern[j + line_offset] = char
        end
        line_offset = line_offset + offset
    end
    return flat_pattern
end

local function match(x, input, pattern)
    -- print("check: " .. x)
    for i, char in pairs(pattern) do
        local pos = x + i - 1
        -- print(pos .. ": " .. input:sub(pos, pos) .. " < " .. char)
        if input:sub(pos, pos) ~= char then
            -- print(pos)
            -- print(input:sub(pos, pos))
            return false
        end
    end
    -- print(x)
    -- print(input:sub(x, x))
    return true
end

function P2.count(input, pattern, width)
    local count = 0
    local x = 1

    -- do not check the last 2 rows
    local max_x = #input - width * 2 - 2
    while x <= max_x do
        if match(x, input, pattern) then
            count = count + 1
        end

        x = x + 1
        -- do not check the last 2 cols
        if x % width > width - 2 then
            x = x + 2
        end
    end

    return count
end

return P2
