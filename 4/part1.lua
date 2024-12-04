local Part1 = {}

function Part1.reverse_str(str)
    local reversed = {}
    for i = #str, 1, -1 do
        table.insert(reversed, str:sub(i, i))
    end
    return table.concat(reversed)
end

function Part1.find_lines(input)
    local lines = {}

    -- horizontal
    for row = 1, #input do
        table.insert(lines, input[row])
        table.insert(lines, Part1.reverse_str(input[row]))
    end

    -- vertical
    for c = 1, #input[1] do
        local chars = {}
        for r = 1, #input do
            local row = input[r]
            table.insert(chars, row:sub(c, c))
        end

        local vertical = table.concat(chars)
        table.insert(lines, vertical)
        table.insert(lines, Part1.reverse_str(vertical))
    end

    -- top-down diagonal
    do
        for start_c = 1, #input[1] do
            local chars = {}
            local r, c = 1, start_c
            while r <= #input and c <= #input[1] do
                local row = input[r]
                table.insert(chars, row:sub(c, c))
                r = r + 1
                c = c + 1
            end

            local diagonal = table.concat(chars)
            table.insert(lines, diagonal)
            table.insert(lines, Part1.reverse_str(diagonal))
        end

        for start_r = 2, #input do
            local chars = {}
            local r, c = start_r, 1
            while r <= #input and c <= #input[1] do
                local row = input[r]
                table.insert(chars, row:sub(c, c))
                r = r + 1
                c = c + 1
            end

            local diagonal = table.concat(chars)
            table.insert(lines, diagonal)
            table.insert(lines, Part1.reverse_str(diagonal))
        end
    end

    -- bottom-up diagonals
    do
        for start_c = 1, #input[1] do
            local chars = {}
            local r, c = #input, start_c
            while r >= 1 and c <= #input[1] do
                local row = input[r]
                table.insert(chars, row:sub(c, c))
                r = r - 1
                c = c + 1
            end

            local diagonal = table.concat(chars)
            table.insert(lines, diagonal)
            table.insert(lines, Part1.reverse_str(diagonal))
        end

        for start_r = #input - 1, 1, - 1 do
            local chars = {}
            local r, c = start_r, 1
            while r >= 1 and c <= #input[1] do
                local row = input[r]
                table.insert(chars, row:sub(c, c))
                r = r - 1
                c = c + 1
            end

            local diagonal = table.concat(chars)
            table.insert(lines, diagonal)
            table.insert(lines, Part1.reverse_str(diagonal))
        end
    end

    return lines
end

function Part1.count_occurs(line, pattern)
    local count = 0
    for _ in line:gmatch(pattern) do
        count = count + 1
    end
    return count
end

return Part1
