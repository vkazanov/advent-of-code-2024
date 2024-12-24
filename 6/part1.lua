local DIRS = {
    {-1, 0 }, {0, 1 }, {1, 0 }, {0, -1}
}

local function find_guard(map)
    for row = 1, #map do
        local col = string.find(map[row], "%^")
        if col then
            return row, col
        end
    end
    assert(false, "No guard found")
end

-- TODO: huh? is there a nicer way
local function change_dir(dir_i)
    local new_dir_i = (dir_i + 1) % 5
    if new_dir_i == 0 then new_dir_i = 1 end
    return new_dir_i
end

local function guard_step(map, pos_set, dir_i, row, col)
    pos_set[row .. "," .. col] = true

    -- print("dir: " .. dir_i)
    local next_dir = DIRS[dir_i]
    -- print(table.concat(next_dir, ","))

    local new_row = row + next_dir[1]
    local new_col = col + next_dir[2]
    -- print("to " .. new_row .. "/" .. new_col)

    -- done
    if new_row > #map or new_row < 1 or new_col > #map[1] or new_col < 1 then
        local pos_num = 0
        for _ in pairs(pos_set) do
            pos_num = pos_num + 1
        end
        return pos_num
    end

    -- obstacle
    if map[new_row]:sub(new_col, new_col) == "#" then
        local new_dir_i = change_dir(dir_i)
        return guard_step(map, pos_set, new_dir_i, row, col)
    end

    -- step
    return guard_step(map, pos_set, dir_i, new_row, new_col)
end

do
    local map = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        table.insert(map, line)
    end
    file:close()

    local row, col = find_guard(map)
    local positions_num = guard_step(map, {}, 1, row, col)
    assert(positions_num == 4454)
end
