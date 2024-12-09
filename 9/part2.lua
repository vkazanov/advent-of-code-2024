local tins = table.insert
local tcon = table.concat
local trem = table.remove

local PRINT = false
-- local PRINT = true

local function readformat(format)
    assert(#format % 2 == 1)

    local output = {}

    local i = 1
    local block_id = 0
    while i < #format do
        local block_size = format[i]; i = i + 1
        local free_size = format[i]; i = i + 1
        if PRINT then print(block_size .. "|" .. free_size) end

        while block_size > 0 do
            tins(output, block_id)
            block_size = block_size - 1
        end

        while free_size > 0 do
            tins(output, -1)
            free_size = free_size - 1
        end

        block_id = block_id + 1
    end

    local block_size = format[i]
    if PRINT then print(block_size) end

    while block_size > 0 do
        tins(output, block_id)
        block_size = block_size - 1
    end

    if PRINT then print(tcon(output, ",")) end
    return output
end

local function span_leftof(input, s_i)
    local s_len = 0
    local s_id = input[s_i]
    while s_i > 0 and s_id == input[s_i] do
        s_len = s_len + 1
        s_i = s_i - 1
    end
    return s_i + 1, s_len
end

local function span_rightof(input, s_i)
    local s_len = 0
    local s_id = input[s_i]
    while s_i <= #input and s_id == input[s_i] do
        s_len = s_len + 1
        s_i = s_i + 1
    end
    return s_i - 1, s_len
end

local function compr(input, r_i)
    if PRINT then
        print(" r_i=" .. tostring(r_i))
        print(tcon(input))
    end
    if not r_i then r_i = #input end

    -- checked everything
    if r_i <= 1 then return end

    -- skip empty space on the right
    while r_i > 1 and input[r_i] == -1 do r_i = r_i - 1 end

    -- find current span to move
    local right_start, right_len = span_leftof(input, r_i)
    if PRINT then print("to move: r_i=" .. right_start .. " len=" .. right_len) end

    -- see if there any suitable size spans on the left of the span
    local span_start = 1

    if PRINT then print("check next empty: i=" .. span_start) end
    local _, span_len = span_rightof(input, span_start)

    while (input[span_start] ~= -1 or span_len < right_len) and span_start < right_start do
        span_start = span_start + span_len

        if PRINT then print("check next empty: i=" .. span_start) end
        _, span_len = span_rightof(input, span_start)
    end

    if span_start >= right_start then
        if PRINT then print("no empty: i=" .. span_start) end
        goto check_next
    end

    -- check if fits and copy
    if PRINT then print("copy to i=" .. span_start .. " from i=" .. right_start) end
    if span_len >= right_len then
        for i = 0, right_len - 1, 1 do
            -- print(i)
            assert(input[span_start + i] == -1)
            assert(input[right_start + i] ~= -1)
            input[span_start + i] = input[right_start + i]
            input[right_start + i] = -1
        end
    end

    ::check_next::
    if PRINT then print("move next") end
    compr(input, right_start - 1)
end

local function checksum(input)
    local sum = 0
    for i, v in ipairs(input) do
        if v ~= -1 then sum = sum + (i - 1) * v end
    end
    return sum
end

do
    local form = {1}
    local un = readformat(form)
    assert(#un == 1)
    assert(un[1] == 0)

    form = {1, 2, 3}
    un = readformat(form)
    assert(#un == 6)
    assert(un[1] == 0)
    assert(un[2] == -1)
    assert(un[3] == -1)
    assert(un[4] == 1)
    assert(un[5] == 1)
    assert(un[6] == 1)

    form = {1, 2, 3, 4, 5}
    un = readformat(form)
    assert(#un == #"0..111....22222")
    assert(un[1] == 0 and un[#un] == 2)

    form = { 2, 3, 3, 3, 1, 3, 3, 1, 2, 1, 4, 1, 4, 1, 3, 1, 4, 0, 2 }
    un = readformat(form)
    assert(#un == #"00...111...2...333.44.5555.6666.777.888899")
    assert(un[3] == -1 and un[#un - 3] == 8)
end

do
    if PRINT then print("NEXT") end

    local input = {-1, -1, 1, 1, -1, -1}
    local s_start, s_len = span_leftof(input, #input)
    assert(s_start == 5 and s_len == 2, s_start .. ":" .. s_len)

    input = {1}
    s_start, s_len = span_leftof(input, #input)
    assert(s_start == 1 and s_len == 1, s_start .. ":" .. s_len)

    input = {1, 1, 1}
    s_start, s_len = span_leftof(input, #input)
    assert(s_start == 1 and s_len == 3, s_start .. ":" .. s_len)

    input = {-1, -1, 1, 1}
    s_start, s_len = span_leftof(input, #input)
    assert(s_start == 3 and s_len == 2, s_start .. ":" .. s_len)

    input = {1, 1, -1, -1}
    s_start, s_len = span_leftof(input, 2)
    assert(s_start == 1 and s_len == 2, s_start .. ":" .. s_len)

    input = {1, 1, 2, 2, 2, 3, 3}
    s_start, s_len = span_leftof(input, 5)
    assert(s_start == 3 and s_len == 3, s_start .. ":" .. s_len)
end

do
    if PRINT then print("NEXT") end

    local input = {1}
    local s_end, s_len = span_rightof(input, 1)
    assert(s_end == 1 and s_len == 1, s_end .. ":" .. s_len)

    input = {1, 1, 1}
    s_end, s_len = span_rightof(input, 1)
    assert(s_end == 3 and s_len == 3, s_end .. ":" .. s_len)

    input = {-1, -1, 1, 1, -1, -1}
    s_end, s_len = span_rightof(input, 1)
    assert(s_end == 2 and s_len == 2, s_end .. ":" .. s_len)

    input = {-1, -1, 1, 1}
    s_end, s_len = span_rightof(input, 3)
    assert(s_end == 4 and s_len == 2, s_end .. ":" .. s_len)

    input = {1, 1, 2, 2, 2, 3, 3}
    s_end, s_len = span_rightof(input, 3)
    assert(s_end == 5 and s_len == 3, s_end .. ":" .. s_len)
end

do
    if PRINT then print("NEXT") end
    local un = { 1, -1, 2 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 3)
    assert(un[1] == 1 and un[2] == 2 and un[3] == -1)
    assert(checksum(un) == 1*0 + 2*1)
end

do
    if PRINT then print("NEXT") end
    local un = { 1, 1, 1, -1, 2 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 5)
    assert(un[1] == 1 and un[2] == 1 and un[3] == 1 and un[4] == 2 and un[5] == -1)
    assert(checksum(un) == 1*0 + 1*1 + 1*2 + 2*3)
end

do
    if PRINT then print("NEXT") end
    local un = { 1, 1, 2, 2, -1, -1, 3 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 7)
    assert(un[1] == 1 and un[2] == 1 and un[3] == 2 and un[4] == 2 and un[5] == 3 and un[6] == -1 and un[7] == -1)
    assert(checksum(un) == 1*0 + 1*1 + 2*2 + 2*3 + 3*4)
end

do
    if PRINT then print("NEXT") end
    local un = { 1, 1, 2, 2, -1, -1, 3, 3 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 8)
    assert(un[1] == 1 and un[2] == 1 and un[3] == 2 and un[4] == 2 and un[5] == 3 and un[6] == 3 and un[7] == -1 and un[8] == -1)
    assert(checksum(un) == 1*0 + 1*1 + 2*2 + 2*3 + 3*4 + 3*5)
end

do
    -- no move
    if PRINT then print("NEXT") end
    local un = { 1, 1, 2, 2, -1, -1, 3, 3, 3 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 9)
    assert(un[1] == 1
           and un[2] == 1
           and un[3] == 2
           and un[4] == 2
           and un[5] == -1
           and un[6] == -1
           and un[7] == 3
           and un[8] == 3
           and un[9] == 3)
end

do
    -- no move
    if PRINT then print("NEXT") end
    local un = { 1, 1, 2, 2, -1, -1, 4, 4, 3, 3, 3 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 11)
    assert(un[1] == 1
           and un[2] == 1
           and un[3] == 2
           and un[4] == 2
           and un[5] == 4
           and un[6] == 4
           and un[7] == -1
           and un[8] == -1
           and un[9] == 3
           and un[10] == 3
           and un[10] == 3)
end



do
    if PRINT then print("NEXT") end
    local un = { 1, -1, 2, 2 }
    compr(un)
    assert(#un == 4)
    assert(un[1] == 1 and un[2] == -1 and un[3] == 2 and un[3] == 2)
    assert(checksum(un) == 1*0 + 0*1 + 2*2 + 2*3)
end

do
    if PRINT then print("NEXT") end
    local un = {
        0, 0, -1, -1, -1, 1, 1, 1, -1, -1, -1, 2, -1, -1, -1, 3, 3, 3, -1, 4, 4, -1, 5, 5, 5, 5, -1, 6, 6, 6, 6, -1, 7, 7, 7, -1, 8, 8, 8, 8, 9, 9,
    }
    assert(#un == #"00...111...2...333.44.5555.6666.777.888899")
    compr(un)
    -- "00992111777.44.333....5555.6666.....8888.."
    assert(un[1] == 0 and
           un[2] == 0 and
           un[3] == 9 and
           un[4] == 9 and
           un[5] == 2 and
           un[6] == 1 and
           -- ...
           un[#un-3] == 8 and
           un[#un-2] == 8 and
           un[#un-1] == -1 and
           un[#un] == -1
    )
    assert(checksum(un) == 2858)
end
do
    local input = {}
    local line = io.open("input.txt", "r"):read("*all")
    for i = 1, #line do tins(input, tonumber(line:sub(i, i))) end
    assert(#input == 19999, #input)
    assert(input[1] == 9)
    assert(input[2] == 8)
    assert(input[#input] == 9)

    local un = readformat(input)
    compr(un)
    assert(checksum(un) == 6427437134372)
end
