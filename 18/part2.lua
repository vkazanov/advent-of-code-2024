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

local function find_path(map, sp, ep)
    local pq = PQ.new()
    pq:enqueue({ sp, sp }, 0)
    local p
    local pos2prev = {}

    while true do
        local pp, s

        if pq:empty() then return nil end
        pp, s = pq:dequeue()
        p = tunp(pp)

        if p == ep then return s, pos2prev end

        for _, next_p in pairs { p:left(), p:right(), p:up(), p:down() } do
            if next_p.x < 0 or next_p.x >= map.dim.width then goto continue end
            if next_p.y < 0 or next_p.y >= map.dim.height then goto continue end
            if map[next_p] ~= "." then goto continue end
            if not pos2prev[next_p] then
                pos2prev[next_p] = p
                pq:enqueue({ next_p, p }, s + 1)
            end

            ::continue::
        end
    end
end

local function mark(map, p, sp, pos2prev)
    while true do
        print(p)
        map[p] = "X"
        local prev_p = pos2prev[p]; assert(prev_p)
        if p == sp then break end
        p = prev_p
    end
end

local function reset(map)
    map:apply(function (p, ch) if ch == "X" then map[p] = "." end end)
end

local s, pos2prev = find_path(m, spos, epos)
mark(m, epos, spos, pos2prev)
for _, c in ipairs(corrupted) do
    if m[c] ~= "X" then
        m[c] = "#"
        goto continue
    end
    if m[c] == "X" then
        m[c] = "#"
        reset(m)
        s, pos2prev = find_path(m, spos, epos)
        if not s then
            print(c)
            break
        end
        mark(m, epos, spos, pos2prev)
        goto continue
    end

    ::continue::
end

m:print()
