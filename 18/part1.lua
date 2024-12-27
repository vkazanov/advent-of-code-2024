local PQ = require "PriorityQueue"

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

local spos, m, epos

spos = vec { 0, 0 }
epos = vec { 70, 70 }
m = aoc.empty_map(epos)

local corrupted = {}
for l in aoc.flines() do
    local x, y = l:match("(%d+),(%d+)")
    local c = vec { tonumber(x), tonumber(y) }
    tins(corrupted, c)
end

for c = 1, 1024 do m[corrupted[c]] = "#" end

local pq = PQ.new()
pq:enqueue(spos, 0)

local res
while not pq:empty() do
    local p, s = pq:dequeue()
    m[p] = "X"
    if p == epos then res = s break end

    for _, next_p in pairs { p:left(), p:right(), p:up(), p:down() } do

        if next_p.x < 0 or next_p.x >= m.dim.width then goto continue end
        if next_p.y < 0 or next_p.y >= m.dim.height then goto continue end
        if m[next_p] ~= "." then goto continue end

        if not pq:contains(next_p) then pq:enqueue(next_p, s + 1) end
        ::continue::
    end
end

assert(res == 408)
