local aoc = require "aoc"

aoc.PRINT = false

local mayprint = aoc.mayprint
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem

local function readformat(format)
    assert(#format % 2 == 1)

    local output = {}

    local i = 1
    local block_id = 0
    while i < #format do
        local block_size = format[i]; i = i + 1
        local free_size = format[i]; i = i + 1
        mayprint(block_size .. "|" .. free_size)

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
    mayprint(block_size)

    while block_size > 0 do
        tins(output, block_id)
        block_size = block_size - 1
    end

    mayprint(tcon(output, ","))
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
    mayprint(" r_i=" .. tostring(r_i))
    mayprint(tcon(input))

    if not r_i then r_i = #input end

    -- checked everything
    if r_i <= 1 then return end

    -- skip empty space on the right
    while r_i > 1 and input[r_i] == -1 do r_i = r_i - 1 end

    -- find current span to move
    local right_start, right_len = span_leftof(input, r_i)
    mayprint("to move: r_i=" .. right_start .. " len=" .. right_len)

    -- see if there any suitable size spans on the left of the span
    local span_start = 1

    mayprint("check next empty: i=" .. span_start)
    local _, span_len = span_rightof(input, span_start)

    while (input[span_start] ~= -1 or span_len < right_len) and span_start < right_start do
        span_start = span_start + span_len

        mayprint("check next empty: i=" .. span_start)
        _, span_len = span_rightof(input, span_start)
    end

    if span_start >= right_start then
        mayprint("no empty: i=" .. span_start)
        goto check_next
    end

    -- check if fits and copy
    mayprint("copy to i=" .. span_start .. " from i=" .. right_start)
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
    mayprint("move next")
    return compr(input, right_start - 1)
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
    mayprint("NEXT")

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
    mayprint("NEXT")

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
    mayprint("NEXT")
    local un = { 1, -1, 2 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 3)
    assert(un[1] == 1 and un[2] == 2 and un[3] == -1)
    assert(checksum(un) == 1*0 + 2*1)
end

do
    mayprint("NEXT")
    local un = { 1, 1, 1, -1, 2 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 5)
    assert(un[1] == 1 and un[2] == 1 and un[3] == 1 and un[4] == 2 and un[5] == -1)
    assert(checksum(un) == 1*0 + 1*1 + 1*2 + 2*3)
end

do
    mayprint("NEXT")
    local un = { 1, 1, 2, 2, -1, -1, 3 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 7)
    assert(un[1] == 1 and un[2] == 1 and un[3] == 2 and un[4] == 2 and un[5] == 3 and un[6] == -1 and un[7] == -1)
    assert(checksum(un) == 1*0 + 1*1 + 2*2 + 2*3 + 3*4)
end

do
    mayprint("NEXT")
    local un = { 1, 1, 2, 2, -1, -1, 3, 3 }
    compr(un)
    -- print(tcon(un))
    assert(#un == 8)
    assert(un[1] == 1 and un[2] == 1 and un[3] == 2 and un[4] == 2 and un[5] == 3 and un[6] == 3 and un[7] == -1 and un[8] == -1)
    assert(checksum(un) == 1*0 + 1*1 + 2*2 + 2*3 + 3*4 + 3*5)
end

do
    -- no move
    mayprint("NEXT")
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
    mayprint("NEXT")
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
    mayprint("NEXT")
    local un = { 1, -1, 2, 2 }
    compr(un)
    assert(#un == 4)
    assert(un[1] == 1 and un[2] == -1 and un[3] == 2 and un[3] == 2)
    assert(checksum(un) == 1*0 + 0*1 + 2*2 + 2*3)
end

do
    mayprint("NEXT")
    local un = {
        0, 0, -1, -1, -1, 1, 1, 1, -1, -1, -1, 2, -1, -1, -1, 3, 3, 3, -1, 4, 4, -1, 5, 5, 5, 5, -1, 6, 6, 6, 6, -1, 7, 7, 7, -1, 8, 8, 8, 8, 9, 9,
    }
    assert(#un == #"00...111...2...333.44.5555.6666.777.888899")
    compr(un)
    local correct = aoc.str_to_arr(
        "00992111777.44.333....5555.6666.....8888..",
        function (n) return n == "." and -1 or tonumber(n) end
    )
    assert(aoc.arr_eq(un, correct))
    assert(checksum(un) == 2858)
end

do
    local input = {}
    local line = aoc.fline("input.txt")
    for i = 1, #line do aoc.tins(input, tonumber(line:sub(i, i))) end
    assert(#input == 19999, #input)
    assert(input[1] == 9)
    assert(input[2] == 8)
    assert(input[#input] == 9)

    local un = readformat(input)
    compr(un)
    assert(checksum(un) == 6427437134372)
end
