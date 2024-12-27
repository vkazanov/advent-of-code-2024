local aoc = require "aoc"

local vec = aoc.vec

local function quad(p, dim)
    if dim.x % 2 > 0 and p.x == dim.x // 2 then return -1 end
    if dim.y % 2 > 0 and p.y == dim.y // 2 then return -1 end
    assert(p)
    assert(dim)

    if p.x < dim.x // 2 and p.y < dim.y // 2 then return 1 end
    if p.x < dim.x and p.y < dim.y // 2 then return 2 end
    if p.x < dim.x // 2 and p.y < dim.y then return 3 end
    if p.x < dim.x and p.y < dim.y then return 4 end

    assert(false, "unwrapped vector: " .. tostring(p) .. " dim: " .. tostring(dim))
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
    assert(factor == 218433348)
end
