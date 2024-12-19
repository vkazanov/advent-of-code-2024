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

local function count(s, pats, cache)
    assert(cache)

    local res = cache[s]
    if res then return cache[s] end

    if #s == 0 then return 1 end

    res = 0
    for _, p in ipairs(pats) do
        if s:sub(1, #p) == p then
            res = res + count(s:sub(#p + 1), pats, cache)
        end
    end

    cache[s] = res

    return res
end

local input = aoc.flines()
local pat_line = input()

local pats = {}
for p in pat_line:gmatch("([a-z]+)") do
    tins(pats, p)
end

input()

local res = 0
local cache = {}
for l in input do res = res + count(l, pats, cache) end
assert(res == 603191454138773)
