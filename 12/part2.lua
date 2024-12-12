local aoc = require "aoc"

aoc.PRINT = true
local mayprint = aoc.mayprint

local pos = aoc.pos
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function check(map, queue, acc)
    map:print()

    queue = queue or { pos { 1, 1 } }
    acc = acc or 0

    local first_region_pos = nil
    while #queue > 0 do
        local p = trem(queue)
        if map[p] ~= "." then
            first_region_pos = p
            break
        end
    end
    if not first_region_pos then return acc end

    local region_area = 0
    local region_queue = {[first_region_pos] = true}
    local region_seen = {}

    local this_pos = next(region_queue)
    while this_pos do
        region_queue[this_pos] = nil
        region_seen[this_pos] = true

        local this_plant = map[this_pos]
        assert(this_plant)
        assert(this_plant ~= ".")
        assert(this_pos)

        region_area = region_area + 1

        local next_poss = { this_pos:up(), this_pos:right(), this_pos:down(), this_pos:left() }
        for _, next_pos in ipairs(next_poss) do
            local next_plant

            -- previously seen region posn
            if region_seen[next_pos] then
                goto continue
            end

            -- map end
            if not map[next_pos] then
                goto continue
            end

            next_plant = map[next_pos]
            -- same region
            if next_plant == this_plant then
                region_queue[next_pos] = true
                goto continue
            end

            -- other region
            if next_plant ~= this_plant then
                if next_plant ~= "." then
                    tins(queue, next_pos)
                end
                goto continue
            end

            ::continue::
        end

        this_pos = next(region_queue)
    end

    for k, _ in pairs(region_seen) do map[k] = "." end

    local side_count = 0

    local is_new_side = function(p, prev_is_side, opposite_to)
        local in_region = region_seen[p]
        if not in_region then return false, false end

        local is_side = not region_seen[opposite_to(p)]
        if not is_side then return false, false end
        if prev_is_side then return true, false end

        return true, true
    end

    -- check left vertical region sides
    local opposite_to = function (p) return p:left() end
    for c = 1, map.dim.width do
        local prev_is_side = false
        for r = 1, map.dim.height do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_to)
            if is_new then side_count = side_count + 1 end
        end
    end

    -- check right vertical region sides
    opposite_to = function (p) return p:right() end
    for c = 1, map.dim.width do
        local prev_is_side = false
        for r = 1, map.dim.height do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_to)
            if is_new then side_count = side_count + 1 end
        end
    end

    -- check up horizontal region sides
    opposite_to = function (p) return p:up() end
    for r = 1, map.dim.height do
        local prev_is_side = false
        for c = 1, map.dim.width do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_to)
            if is_new then side_count = side_count + 1 end
        end
    end

    -- check down horizontal region sides
    opposite_to = function (p) return p:down() end
    for r = 1, map.dim.height do
        local prev_is_side = false
        for c = 1, map.dim.width do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_to)
            if is_new then side_count = side_count + 1 end
        end
    end

    return check(map, queue, acc + region_area * side_count)
end

aoc.PRINT = false

do
    local map_str = [[
AAA
AAA
AAA
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 9 * 4, price)

    mayprint("DONE")
end

do
    local map_str = [[
AA
AA
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 4 * 4, price)

    mayprint("DONE")
end

do
    local map_str = [[
A
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 4 * 1, price)

    mayprint("DONE")
end

do
    local map_str = [[
AB
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 4 * 1 * 2, price)

    mayprint("DONE")
end

do
    local map_str = [[
ABA
BBB
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 4 * 1 * 2 + (3 + 1 + 2 + 2)*4, price)

    mayprint("DONE")
end

do
    local map_str = [[
E
X
E
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 4*3, price)

    mayprint("DONE")
end

do
    local map_str = [[
EE
EX
EE
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 8*5 + 4*1, price)

    mayprint("DONE")
end

do
    local map_str = [[
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 236, price)

    mayprint("DONE")
end

do
    local map_str = [[
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 368, price)

    mayprint("DONE")
end

do
    local map_str = [[
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 1206, price)

    mayprint("DONE")
end

do
    local m = aoc.mappify(aoc.flines("input.txt"))
    local price = check(m)
    assert(price == 784982, price)

    mayprint("DONE")
end
