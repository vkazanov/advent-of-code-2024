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
    for _, p in ipairs(pats) do
        if ss:sub(1, #p) == p then
            if check(s, i + #p, pats) then return true end
        end
    end

    return false
end

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
