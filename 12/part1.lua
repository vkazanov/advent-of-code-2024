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
    mayprint("CHECK")
    map:print()

    queue = queue or { pos { 1, 1 } }
    acc = acc or 0

    local first_region_pos = nil
    for _, p in ipairs(queue) do
        assert(map[p])
        if map[p] and map[p] ~= "." then
            first_region_pos = p
            break
        end
    end
    if not first_region_pos then return acc end

    local region_area, region_perimeter = 0, 0
    local region_queue = {[first_region_pos] = true}
    local region_seen = {}

    local this_pos = next(region_queue)
    while this_pos do
        mayprint("LOOK AT: " .. tostring(this_pos))
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
                region_perimeter = region_perimeter + 1
                goto continue
            end

            next_plant = map[next_pos]
            -- same region
            if next_plant == this_plant then
                -- mayprint("next region added: " .. tostring(next_pos))
                region_queue[next_pos] = true
                goto continue
            end

            -- other region
            if next_plant ~= this_plant then
                region_perimeter = region_perimeter + 1
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

    mayprint("NEXT REGION")
    return check(map, queue, acc + region_area * region_perimeter)
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
    assert(price == 9 * 12, price)

    mayprint("DONE")
end

do
    local map_str = [[
AAAB
AAAB
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 6*10 + 2*6, price)
end

do
    local map_str = [[
AAAA
BBCD
BBCC
EEEC
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 140, price)
end

do
    local map_str = [[
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
]]
    local m = aoc.mappify(map_str:gmatch("[^\n]+"))
    local price = check(m)
    assert(price == 772, price)
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
    assert(price == 1930, price)
end

do
    aoc.PRINT = false
    local m = aoc.mappify(aoc.flines("input.txt"))
    local price = check(m)
    print(price)

    aoc.PRINT = true
end
