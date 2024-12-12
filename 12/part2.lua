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
        -- mayprint("LOOK AT: " .. tostring(this_pos))
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
    -- for k, _ in pairs(region_seen) do mayprint("SEEN:" .. tostring(k)) end

    -- check left vertical region sides
    local left_count = 0
    for c = 1, map.dim.width do
        for r = 1, map.dim.height do
            local p = pos { r, c }
            mayprint(p)
            local in_region = region_seen[p]
            if not in_region then goto continue end
            mayprint("in region")

            local up_in_region = region_seen[p:up()]
            mayprint("up_in_region: " .. tostring(up_in_region))

            local left_not_seen = not region_seen[pos { p.r, p.c - 1 }]
            mayprint("left_not_seen: " .. tostring(left_not_seen))

            local up_left_not_seen = not region_seen[pos { p.r - 1, p.c - 1 }]
            mayprint("up_left_not_seen: " .. tostring(up_left_not_seen))

            if left_not_seen and not (up_left_not_seen and up_in_region) then
                mayprint("add")
                left_count = left_count + 1
            end
            ::continue::
        end
    end
    mayprint("LEFT SIDES = " .. left_count)

    -- check right vertical region sides
    local right_count = 0
    for c = 1, map.dim.width do
        for r = 1, map.dim.height do
            local p = pos { r, c }
            mayprint(p)

            local in_region = region_seen[p]
            if not in_region then goto continue end
            mayprint("in region")

            local up_in_region = region_seen[p:up()]
            mayprint("up_in_region: " .. tostring(up_in_region))

            local right_not_seen = not region_seen[pos { p.r, p.c + 1 }]
            mayprint("right_not_seen: " .. tostring(right_not_seen))

            local up_right_not_seen = not region_seen[pos { p.r - 1, p.c + 1 }]
            mayprint("up_right_not_seen: " .. tostring(up_right_not_seen))

            if right_not_seen and not (up_right_not_seen and up_in_region) then
                right_count = right_count + 1
                mayprint("add")
            end
            ::continue::
        end
    end
    mayprint("RIGHT SIDES = " .. right_count)

    -- check up horizontal region sides
    local up_count = 0
    for c = 1, map.dim.width do
        for r = 1, map.dim.height do
            local p = pos { r, c }
            mayprint(p)

            local in_region = region_seen[p]
            if not in_region then goto continue end
            mayprint("in region")

            local left_in_region = region_seen[p:left()]
            mayprint("left_in_region: " .. tostring(left_in_region))

            local up_not_seen = not region_seen[pos { p.r - 1, p.c }]
            mayprint("up_not_seen: " .. tostring(up_not_seen))

            local up_left_not_seen = not region_seen[pos { p.r - 1, p.c - 1 }]
            mayprint("up_left_not_seen: " .. tostring(up_left_not_seen))

            if up_not_seen and not (up_left_not_seen and left_in_region) then
                up_count = up_count + 1
            end
            ::continue::
        end
    end
    mayprint("UP SIDES = " .. up_count)

    -- check down horizontal region sides
    local down_count = 0
    for c = 1, map.dim.width do
        for r = 1, map.dim.height do
            local p = pos { r, c }
            mayprint(p)
            local in_region = region_seen[p]
            if not in_region then goto continue end
            mayprint("in region")

            local left_in_region = region_seen[p:left()]
            mayprint("left_in_region: " .. tostring(left_in_region))

            local down_not_seen = not region_seen[pos { p.r + 1, p.c }]
            mayprint("down_not_seen: " .. tostring(down_not_seen))

            local down_left_not_seen = not region_seen[pos { p.r + 1, p.c - 1 }]
            mayprint("down_left_not_seen: " .. tostring(down_left_not_seen))

            if down_not_seen and not (down_left_not_seen and left_in_region) then
                down_count = down_count + 1
            end
            ::continue::
        end
    end
    mayprint("DOWN SIDES = " .. down_count)

    mayprint("NEXT REGION")
    return check(map, queue, acc + region_area * (down_count + up_count + left_count + right_count))
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
