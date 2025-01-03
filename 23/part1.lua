local aoc = require "aoc"

local Set = aoc.Set

local computers = Set()
local conns = {}
for line in aoc.flines() do
    local l, r = line:gmatch("([^\n-]+)-([^\n-]+)")()
    if not conns[l] then conns[l] = Set() end
    if not conns[r] then conns[r] = Set() end
    conns[l]:add(r)
    conns[r]:add(l)
    computers:add(l)
    computers:add(r)
end

local function find_cliques(r, p, x, report)
    if r:size() == 3 then
        for c in pairs(r) do
            if c:sub(1, 1) == "t" then
                report(r)
                break
            end
        end
    end

    for v in pairs(p) do
        local conn_vs = conns[v]
        find_cliques(r:union(Set { v }), p:intersect(conn_vs), x:intersect(conn_vs),
                     report)
        p = p:diff(Set { v })
        x = x:union(Set { v })
    end
end

local counter = 0
local function count_cliques(c) counter = counter + 1 end
find_cliques(Set(), computers, Set(), count_cliques)

assert(counter, 1077, counter)
