local aoc = require "aoc"

aoc.PRINT = false
local mayprint = aoc.mayprint

-- TODO: rename positions into vectors
local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function quad(p, dim)
    if dim.x % 2 > 0 and p.x == dim.x // 2 then return -1 end
    if dim.y % 2 > 0 and p.y == dim.y // 2 then return -1 end
    assert(p)
    assert(dim)

    mayprint(p)
    mayprint(dim)

    if p.x < dim.x // 2 and p.y < dim.y // 2 then return 1 end
    if p.x < dim.x and p.y < dim.y // 2 then return 2 end
    if p.x < dim.x // 2 and p.y < dim.y then return 3 end
    if p.x < dim.x and p.y < dim.y then return 4 end

    assert(false, "unwrapped vector: " .. tostring(p) .. " dim: " .. tostring(dim))
end

do
    aoc.PRINT = false

    local r = vec { 0, 0 }
    local v = vec { 1, 1 }

    assert(r == vec {0, 0})
    r = r + v:times(1)
    assert(r == vec {1, 1})

    r = r:wrap(vec { 4, 4 })
    assert(r == vec {1, 1})

    r = r + v:times(3)
    r = r:wrap(vec { 4, 4 })
    assert(r == vec {0, 0})
end

do
    aoc.PRINT = false

    assert(quad(vec { 0, 0 }, vec { 4, 4 }) == 1)
    assert(quad(vec { 2, 0 }, vec { 4, 4 }) == 2)
    assert(quad(vec { 0, 2 }, vec { 4, 4 }) == 3)
    assert(quad(vec { 2, 2 }, vec { 4, 4 }) == 4)

    assert(quad(vec { 2, 0 }, vec { 5, 5 }) == -1)
    assert(quad(vec { 0, 2 }, vec { 5, 5 }) == -1)
    assert(quad(vec { 2, 2 }, vec { 5, 5 }) == -1)
end

do
    aoc.PRINT = false

    local dim = vec {11, 7}
    local quad_to_count = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [-1] = 0}
    local robot_strs = [[
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
]]
    for line in robot_strs:gmatch("([^\n]+)") do
        local nums = line:gmatch("[%d-]+")
        local p = vec { tonumber(nums()), tonumber(nums()) }
        local v = vec { tonumber(nums()), tonumber(nums()) }
        p = p + v:times(100)
        p = p:wrap(dim)
        quad_to_count[quad(p, dim)] = quad_to_count[quad(p, dim)] + 1
    end

    assert(quad_to_count[1] == 1)
    assert(quad_to_count[2] == 3)
    assert(quad_to_count[3] == 4)
    assert(quad_to_count[4] == 1)
end

do
    local quad_to_count = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [-1] = 0}
    local dim = vec {101, 103}

    for line in aoc.flines() do
        local nums = line:gmatch("[%d-]+")
        local p = vec { tonumber(nums()), tonumber(nums()) }
        local v = vec { tonumber(nums()), tonumber(nums()) }
        p = p + v:times(100)
        p = p:wrap(dim)
        quad_to_count[quad(p, dim)] = quad_to_count[quad(p, dim)] + 1
    end

    local factor = quad_to_count[1] * quad_to_count[2] * quad_to_count[3] * quad_to_count[4]
    print(factor)
end
