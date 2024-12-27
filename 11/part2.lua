local aoc = require "aoc"

local tins = table.insert
local ssplit = aoc.str_split

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
    local input = aoc.fline("input.txt")
    local stones = ssplit(input)
    assert(blink(stones, 75) == 259112729857522)
end
