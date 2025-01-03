local aoc = require "aoc"

local tcon = table.concat
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

local function find_max_cliques(r, p, x, report)
    if p:is_empty() and x:is_empty() then
        report(r)
    end

    for v in pairs(p) do
        local conn_vs = conns[v]
        find_max_cliques(r:union(Set { v }), p:intersect(conn_vs), x:intersect(conn_vs),
                     report)
        p = p:diff(Set { v })
        x = x:union(Set { v })
    end
end

local max_c = Set()
local function find_largest(c)
    if c:size() > max_c:size() then
        max_c = c
    end
end
find_max_cliques(Set(), computers, Set(), find_largest)
local comps = max_c:members()
table.sort(comps)

assert(tcon(comps, ",") == "bc,bf,do,dw,dx,ll,ol,qd,sc,ua,xc,yu,zt")
