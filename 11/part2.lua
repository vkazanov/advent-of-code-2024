local aoc = require "aoc"

aoc.PRINT = true
local mayprint = aoc.mayprint

local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local tmov = aoc.tmov

local ssplit = aoc.str_split
local aeq = aoc.arr_eq

local function blink_stone(stone)
    local stones = {}

    if stone == 0 then
        tins(stones, 1)
        return stones
    end

    local sstr = tostring(stone)
    if #sstr % 2 == 0 then
        tins(stones, tonumber(sstr:sub(1, #sstr / 2)))
        tins(stones, tonumber(sstr:sub(#sstr / 2 + 1, -1)))
        return stones
    end

    tins(stones, stone * 2024)
    return stones
end

local function blink(stones, times, cache)
    if not times then times = 1 end
    if not cache then cache = {} end
    if times == 0 then return #stones end

    local count = 0
    for _, s in ipairs(stones) do
        local cache_key = s .. "*" .. times
        local s_count = cache[cache_key] or blink(blink_stone(s), times - 1, cache)
        cache[cache_key] = s_count
        count = count + s_count
    end

    return count
end


do
    assert(aeq(blink_stone(0), {1}))
    assert(aeq(blink_stone(1), {2024}))
    assert(aeq(blink_stone(11), {1, 1}))
    assert(aeq(blink_stone(1101), {11, 1}))
    assert(aeq(blink_stone(1), {2024}))
    assert(aeq(blink_stone(3), {3*2024}))
end


do
    local stones = ssplit("0 1 10 99 999")
    assert(blink(stones) == #ssplit"1 2024 1 0 9 9 2021976")
end

do
    local input = aoc.fline("input.txt")
    local stones = ssplit(input)
    assert(#stones == 8)

    assert(blink(stones, 25) == 217812)
end

do
    local input = aoc.fline("input.txt")
    local stones = ssplit(input)
    assert(#stones == 8)

    assert(blink(stones, 33) ==  6153500)
end

do
    local input = aoc.fline("input.txt")
    local stones = ssplit(input)
    assert(#stones == 8)

    assert(blink(stones, 75) == 259112729857522)
end
