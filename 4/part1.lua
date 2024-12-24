local tins = table.insert
local tcon = table.concat

local function reverse_str(str)
    local reversed = {}
    for i = #str, 1, -1 do
        tins(reversed, str:sub(i, i))
    end
    return tcon(reversed)
end

local function find_lines(input)
    local lines = {}

    -- horizontal
    for row = 1, #input do
        tins(lines, input[row])
        tins(lines, reverse_str(input[row]))
    end

    -- vertical
    for c = 1, #input[1] do
        local chars = {}
        for r = 1, #input do
            local row = input[r]
            tins(chars, row:sub(c, c))
        end

        local vertical = tcon(chars)
        tins(lines, vertical)
        tins(lines, reverse_str(vertical))
    end

    -- top-down diagonal
    do
        for start_c = 1, #input[1] do
            local chars = {}
            local r, c = 1, start_c
            while r <= #input and c <= #input[1] do
                local row = input[r]
                tins(chars, row:sub(c, c))
                r = r + 1
                c = c + 1
            end

            local diagonal = tcon(chars)
            tins(lines, diagonal)
            tins(lines, reverse_str(diagonal))
        end

        for start_r = 2, #input do
            local chars = {}
            local r, c = start_r, 1
            while r <= #input and c <= #input[1] do
                local row = input[r]
                tins(chars, row:sub(c, c))
                r = r + 1
                c = c + 1
            end

            local diagonal = tcon(chars)
            tins(lines, diagonal)
            tins(lines, reverse_str(diagonal))
        end
    end

    -- bottom-up diagonals
    do
        for start_c = 1, #input[1] do
            local chars = {}
            local r, c = #input, start_c
            while r >= 1 and c <= #input[1] do
                local row = input[r]
                tins(chars, row:sub(c, c))
                r = r - 1
                c = c + 1
            end

            local diagonal = tcon(chars)
            tins(lines, diagonal)
            tins(lines, reverse_str(diagonal))
        end

        for start_r = #input - 1, 1, - 1 do
            local chars = {}
            local r, c = start_r, 1
            while r >= 1 and c <= #input[1] do
                local row = input[r]
                tins(chars, row:sub(c, c))
                r = r - 1
                c = c + 1
            end

            local diagonal = tcon(chars)
            tins(lines, diagonal)
            tins(lines, reverse_str(diagonal))
        end
    end

    return lines
end

local function count_occurs(line, pattern)
    local count = 0
    for _ in line:gmatch(pattern) do
        count = count + 1
    end
    return count
end


local input = {}
for line in io.open("input.txt", "r"):lines() do
    tins(input, line)
end

local lines = find_lines(input)
local count = 0
for _, line in pairs(lines) do
    count = count + count_occurs(line, "XMAS")
end
assert(count == 2685)
