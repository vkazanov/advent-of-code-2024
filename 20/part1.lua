local PQ = require "PriorityQueue"

local aoc = require "aoc"
aoc.PRINT = false
local mayprint = aoc.mayprint

local Vec = aoc.Vec

local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local tins = table.insert
local tcon = table.concat
local trem = table.remove
local tunp = table.unpack
local tpck = table.pack


local function find(m, sp, ep)
    local pq = PQ.new()
    local pos2prev = {}
    local pos2time = {}

    pq:enqueue({sp, sp}, 0)
    while not pq:empty() do
        local pp, s = pq:dequeue()
        local p = tunp(pp)
        if p == ep then
            print("end reached in " .. tostring(s))
            break
        end

        for _, next_p in pairs { p:left(), p:right(), p:up(), p:down() } do
            if not m:in_bounds(next_p) then goto continue end
            if m[next_p] ~= "." then goto continue end
            local next_s = s + 1

            if not pos2prev[next_p] then
                pos2prev[next_p] = p
                pos2time[next_p] = next_s
                pq:enqueue({ next_p, p }, next_s)
            end

            ::continue::
        end
    end

    return pos2prev, pos2time
end

local function count(m, sp, ep, p2p, p2t)
    local p = ep
    local cnt = 0
    repeat
        for _, cheat_p in pairs { p:left():left(), p:right():right(),
            p:up():up(), p:down():down() } do
            if not m:in_bounds(cheat_p) then goto continue end
            if not p2t[cheat_p] then goto continue end

            local cheat_time = p2t[p] - p2t[cheat_p] - 2
            if cheat_time >= 100 then cnt = cnt + 1 end
            ::continue::
        end
        p = p2p[p]
    until p == sp
    return cnt
end

local spos, epos
local map = aoc.mappify_lines(
    aoc.flines(),
    function(ch, pos)
        if ch == "S" then
            spos = pos; return "."
        elseif ch == "E" then
            epos = pos; return "."
        end
        return ch
    end
)

local pos2prev, pos2time = find(map, spos, epos)
local cnt = count(map, spos, epos, pos2prev, pos2time)

assert(cnt, 1441)
