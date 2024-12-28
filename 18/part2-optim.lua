local deque = require "deque"

local aoc = require "aoc"
aoc.PRINT = false

local vec = aoc.vec
local tins = aoc.tins

local spos, m, epos

spos = vec { 0, 0 }
epos = vec { 70, 70 }
m = aoc.empty_map(epos)

local function mark(map, sp, ep)
    local queue = deque.new()
    queue:push_left(sp)

    while not queue:is_empty() do
        local p = queue:pop_right()
        map[p] = "X"
        if p == ep then return true end

        for _, next_p in pairs { p:left(), p:right(), p:up(), p:down() } do
            if map:in_bounds(next_p) and map[next_p] == "." then
                queue:push_left(next_p)
            end
        end
    end

    return false
end

local corrupted = {}
for l in aoc.flines() do
    local x, y = l:match("(%d+),(%d+)")
    local c = vec { tonumber(x), tonumber(y) }
    tins(corrupted, c)
end

-- add all broken bytes
for _, c in ipairs(corrupted) do m[c] = "#" end

-- remove the bytes one by one until the end is reacheable
local res
mark(m, spos, epos)
for i = #corrupted, 1, -1 do
    local c = corrupted[i]
    m[c] = "."
    local should_expand = m[c:left()] == "X"
        or m[c:right()] == "X"
        or m[c:up()] == "X"
        or m[c:down()] == "X"
    if should_expand and mark(m, c, epos) then
        res = c
    end
end
assert(tostring(res) == "45,16")
