local aoc = require "aoc"

local pos = aoc.pos

local function check(map, queue, acc)
    queue = queue or { [pos { 1, 1 }] = true }
    acc = acc or 0

    -- flush regions seen already
    local first = next(queue)
    while first and map[first] == "." do
        queue[first] = nil
        first = next(queue)
    end
    if not first then return acc end

    -- flood fill the current region
    local area = 0
    local region_queue = {[first] = true}
    local region_seen = {}

    local min_r, max_r = map.dim.height, 0
    local min_c, max_c = map.dim.width, 0

    local this_pos = next(region_queue)
    while this_pos do
        region_queue[this_pos] = nil
        region_seen[this_pos] = true

        local this_plant = map[this_pos]
        map[this_pos] = "."

        assert(this_plant)
        assert(this_plant ~= ".")
        assert(this_pos)

        min_r = (this_pos.r < min_r) and this_pos.r or min_r
        max_r = (this_pos.r > max_r) and this_pos.r or max_r

        min_c = (this_pos.c < min_c) and this_pos.c or min_c
        max_c = (this_pos.c > max_c) and this_pos.c or max_c

        area = area + 1

        local next_poss = { this_pos:up(), this_pos:right(), this_pos:down(), this_pos:left() }
        for _, next_pos in ipairs(next_poss) do
            local next_plant

            -- seen region posn or not in the map
            if region_seen[next_pos] or not map[next_pos] then goto continue end

            -- same vs other region
            next_plant = map[next_pos]
            if next_plant == this_plant then region_queue[next_pos] = true
            else queue[next_pos] = true end

            ::continue::
        end

        this_pos = next(region_queue)
    end

    -- having finished with the region flood, it's time to find region sides

    local side_count = 0

    local function is_new_side(p, prev_is_side, get_opposite)
        local in_region = region_seen[p]
        if not in_region then return false, false end

        local is_side = not region_seen[get_opposite(p)]
        if not is_side then return false, false end
        if prev_is_side then return true, false end

        return true, true
    end

    -- check left and right vertical region sides
    local function opposite_left(p) return p:left() end
    local function opposite_right(p) return p:right() end
    for c = min_c, max_c do
        local prev_is_side = false
        for r = min_r, max_r do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_right)
            if is_new then side_count = side_count + 1 end
        end

        prev_is_side = false
        for r = min_r, max_r do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_left)
            if is_new then side_count = side_count + 1 end
        end
    end

    -- check up and down horizontal region sides
    local function opposite_up(p) return p:up() end
    local function opposite_down(p) return p:down() end
    for r = min_r, max_r do
        local prev_is_side = false
        for c = min_c, max_c do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_up)
            if is_new then side_count = side_count + 1 end
        end

        prev_is_side = false
        for c = min_c, max_c do
            local is_new
            prev_is_side, is_new = is_new_side(pos { r, c }, prev_is_side, opposite_down)
            if is_new then side_count = side_count + 1 end
        end
    end

    return check(map, queue, acc + area * side_count)
end

do
    local m = aoc.mappify(aoc.flines())
    local price = check(m)
    assert(price == 784982, price)
end
