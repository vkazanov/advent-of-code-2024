local tins = table.insert

local pattern1 = {
    { [1] = "M", [3] = "S" },
    { [2] = "A"},
    { [1] = "M", [3] = "S" },
}

local pattern2 = {
    { [1] = "M", [3] = "M" },
    { [2] = "A"},
    { [1] = "S", [3] = "S" },
}

local pattern3 = {
    { [1] = "S", [3] = "S" },
    { [2] = "A"},
    { [1] = "M", [3] = "M" },
}

local pattern4 = {
    { [1] = "S", [3] = "M" },
    { [2] = "A"},
    { [1] = "S", [3] = "M" },
}

local function flatten(input)
    local width = #input[1]
    local flat = table.concat(input)
    return width, flat
end

local function flatten_pattern(pattern, offset)
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
    for i, char in pairs(pattern) do
        local pos = x + i - 1
        if input:sub(pos, pos) ~= char then
            return false
        end
    end
    return true
end

local function count(input, pattern, width)
    local cnt = 0
    local x = 1

    -- do not check the last 2 rows
    local max_x = #input - width * 2 - 2
    while x <= max_x do
        if match(x, input, pattern) then
            cnt = cnt + 1
        end

        x = x + 1
        -- do not check the last 2 cols
        if x % width > width - 2 then
            x = x + 2
        end
    end

    return cnt
end

local input = {}
for line in io.open("input.txt", "r"):lines() do
    tins(input, line)
end

local width, line = flatten(input)

pattern1 = flatten_pattern(pattern1, width)
pattern2 = flatten_pattern(pattern2, width)
pattern3 = flatten_pattern(pattern3, width)
pattern4 = flatten_pattern(pattern4, width)

local cnt = count(line, pattern1, width)
    + count(line, pattern2, width)
    + count(line, pattern3, width)
    + count(line, pattern4, width)
assert(cnt == 2048)
