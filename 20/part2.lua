local aoc = require "aoc"

local tins = table.insert

local function find(m, sp, ep)
    local pos2prev = {}
    local pos2time = {}

    local p = sp
    local s = 0
    pos2time[sp] = 0
    while true do
        if p == ep then break end

        for _, next_p in pairs { p:left(), p:right(), p:up(), p:down() } do
            if m[next_p] ~= "." then goto continue end
            if pos2time[next_p] then goto continue end

            pos2prev[next_p] = p
            local next_s = s + 1
            pos2time[next_p] = next_s
            p = next_p
            s = next_s
            break

            ::continue::
        end
    end

    return pos2prev, pos2time
end

local function count(ep, p2p, p2t)
    local p = ep
    local cnt = 0
    local path_to_end = {}
    repeat
        for _, cheat_p in pairs(path_to_end) do
            assert(p2t[cheat_p])

            local dist = math.abs(p.x - cheat_p.x) + math.abs(p.y - cheat_p.y)
            if dist > 20 then goto continue end

            local time_saved = p2t[cheat_p] - p2t[p] - dist
            if time_saved >= 100 then cnt = cnt + 1 end

            ::continue::
        end
        tins(path_to_end, p)
        p = p2p[p]
    until not p
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
local cnt = count(epos, pos2prev, pos2time)
assert(cnt == 1021490)
