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
local tsrt = table.sort


local function walk(m, sp, ep)
    local pos2time = {}
    local time2pos = {}

    local p = sp
    local t = 0
    pos2time[sp] = t
    time2pos[t] = p
    while true do
        if p == ep then break end

        for _, next_p in pairs { p:left(), p:right(), p:up(), p:down() } do
            if m[next_p] ~= "." then goto continue end
            if pos2time[next_p] then goto continue end

            local next_t = t + 1
            pos2time[next_p] = next_t
            time2pos[next_t] = next_p
            p = next_p
            t = next_t
            break

            ::continue::
        end
    end

    return pos2time, time2pos
end

local function count(p2t, t2p, epos)
    local cnt = 0
    for p1, t1 in pairs(p2t) do
        local p2 = epos
        local t2 = p2t[p2]
        while t2 - t1 >= 100 do
            local time_saved
            local dist = math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
            local skip = 1
            if dist > 20 then
                skip = dist - 20
                goto continue
            end
            time_saved = t2 - t1 - dist
            if time_saved >= 100 then cnt = cnt + 1 end
            ::continue::
            t2 = t2 - skip
            p2 = t2p[t2]
        end
    end
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

local pos2time, time2pos = walk(map, spos, epos)
local cnt = count(pos2time, time2pos, epos)
assert(cnt == 1021490)
