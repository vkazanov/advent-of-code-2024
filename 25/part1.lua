local aoc = require "aoc"

local Vec = aoc.Vec
local tins = table.insert

local locks, keys = {}, {}

local fline = aoc.fline()
for m_str in fline:gmatch("([#.]+\n[#.]+\n[#.]+\n[#.]+\n[#.]+\n[#.]+\n[#.]+\n)\n") do
    local m = aoc.mappify_lines(m_str:gmatch("[^\n]+"))
    local target = ((m[Vec { 0, 0 }] == "#") and locks or keys)
    local cols = {}
    for x = 0, 4 do
        -- because there will always be a single delimiting row
        local ccount = -1
        for y = 0, 6 do
            if m[Vec { x, y }] == "#" then ccount = ccount + 1 end
        end
        tins(cols, ccount)
    end
    tins(target, cols)
end

local pair_count = 0
for _, lock in ipairs(locks) do
    for _, key in ipairs(keys) do
        for i = 1, #lock do
            if lock[i] + key[i] > 5 then goto overlap end
        end
        pair_count = pair_count + 1
        ::overlap::
    end
end

assert(pair_count == 3077, pair_count)
