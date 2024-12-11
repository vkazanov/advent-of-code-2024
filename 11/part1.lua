local aoc = require "aoc"

aoc.PRINT = true
local mayprint = aoc.mayprint

local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function blink(stones)
    local new_stones = {}
    for _, s in ipairs(stones) do
        if s == 0 then
            tins(new_stones, 1)
            goto continue
        end

        local sstr = tostring(s)
        if #sstr % 2 == 0 then
            tins(new_stones, tonumber(sstr:sub(1, #sstr / 2)))
            tins(new_stones, tonumber(sstr:sub(#sstr / 2 + 1, -1)))
            goto continue
        end

        tins(new_stones, s*2024)

        ::continue::
    end
    return new_stones
end


do
    local stones = ssplit("125 17")
    assert(#stones == 2)
    assert(arreq(stones, {125, 17}))

    stones = blink(stones)
    assert(arreq(stones, {253000, 1, 7}))

    stones = blink(stones)
    assert(arreq(stones, {253, 0, 2024, 14168}))

    stones = blink(stones)
    assert(arreq(stones, ssplit"512072 1 20 24 28676032"))

    stones = blink(stones)
    assert(arreq(stones, ssplit"512 72 2024 2 0 2 4 2867 6032"))

    stones = blink(stones)
    assert(arreq(stones, ssplit"1036288 7 2 20 24 4048 1 4048 8096 28 67 60 32"))

    stones = blink(stones)
    assert(arreq(stones, ssplit "2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2"))

    assert(22)
end


do
    local stones = ssplit("0 1 10 99 999")
    stones = blink(stones)
    assert(arreq(stones, ssplit"1 2024 1 0 9 9 2021976"))
end

do
    local input = aoc.fline("input.txt")
    local stones = ssplit(input)
    assert(#stones == 8)

    local i = 25
    while i > 0 do
        stones = blink(stones)
        i = i - 1
    end
    print(#stones)
end
