local aoc = require("aoc")

local mayprint = aoc.mayprint

local tins = table.insert
local tcon = table.concat
local trem = table.remove

local function readformat(format)
    assert(#format % 2 == 1)

    local output = {}

    local i = 1
    local block_id = 0
    while i < #format do
        local block_size = format[i]; i = i + 1
        local free_size = format[i]; i = i + 1
        if PRINT then mayprint(block_size .. "|" .. free_size) end

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
    if PRINT then mayprint(block_size) end

    while block_size > 0 do
        tins(output, block_id)
        block_size = block_size - 1
    end

    if PRINT then mayprint(tcon(output, ",")) end
    return output
end

local function compr(output, t_i)
    if PRINT then
        mayprint("t_i = " .. tostring(t_i))
        mayprint(tcon(output, ","))
    end

    if #output < 1 then return end
    if output[#output] == -1 then trem(output); compr(output, t_i); return end

    if not t_i then t_i = 1 end
    if t_i >= #output then return end

    if output[t_i] ~= -1 then compr(output, t_i + 1); return end

    local rightmost = trem(output)
    if PRINT then mayprint("move " .. rightmost .. " to " .. t_i) end
    output[t_i] = rightmost
    compr(output, t_i + 1)
end

local function checksum(input)
    local sum = 0
    for i, v in ipairs(input) do
        assert(v > -1, "pos:" .. i .. " val:" .. v)
        sum = sum + (i - 1) * v
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
    compr(un)
    -- print(tcon(un))
    assert(un[1] == 0 and un[2] == 2 and un[3] == 2 and un[4] == 1
           -- -- ...
           and un[#un] == 2
    )
    assert(checksum(un) == 0*0 + 2*1 + 2*2 + 1*3 + 1*4 + 1*5 + 2*6 + 2*7 + 8*2)

    form = { 2, 3, 3, 3, 1, 3, 3, 1, 2, 1, 4, 1, 4, 1, 3, 1, 4, 0, 2 }
    un = readformat(form)
    assert(#un == #"00...111...2...333.44.5555.6666.777.888899")
    assert(un[3] == -1 and un[#un - 3] == 8)
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
    assert(checksum(un) == 6398608069280)
end
