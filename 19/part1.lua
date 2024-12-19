local aoc = require "aoc"
aoc.PRINT = false
local mayprint = aoc.mayprint

local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local tunp = aoc.tunp
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function check(s, i, pats)
    if i > #s then return true end
    local ss = s:sub(i, #s)
    -- print(" " .. ss)
    for _, p in ipairs(pats) do
        -- print("  " .. p)
        if ss:sub(1, #p) == p then
            -- print("   " .. "OK")
            if check(s, i + #p, pats) then return true end
        end
    end

    return false
end

-- local input = [[
-- r, wr, b, g, bwu, rb, gb, br

-- brwrr
-- bggr
-- gbbr
-- rrbgbr
-- ubwu
-- bwurrg
-- brgr
-- bbrgwb
-- ]]
-- local lines = input:gmatch("([^\n]+)")
-- local available = lines()

-- print("Patterns: ", available)
-- local pats = {}
-- for pat in available:gmatch("([a-z]+)") do
--     print(pat)
--     tins(pats, pat)
-- end

-- local res = 0
-- for expected in lines do
--     print("Line: " .. expected)
--     if check(expected, 1, pats) then
--         print("ACCEPT")
--         res = res + 1
--     end
-- end

-- assert(6)

local input = aoc.flines()
local pat_line = input()

local pats = {}
for p in pat_line:gmatch("([a-z]+)") do
    tins(pats, p)
end

input()

local res = 0
for l in input do
    if check(l, 1, pats) then
        res = res + 1
    end
end
print(res)
