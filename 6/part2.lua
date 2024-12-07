local DIRS = {
    {-1, 0 }, {0, 1 }, {1, 0 }, {0, -1}
}

local UP = 1
local RIGHT = 2
local DOWN = 3
local LEFT = 4

local DIR_SYM = {
    [UP] = "^",
    [RIGHT] = ">",
    [DOWN] = "v",
    [LEFT] = "<",
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

local function is_obstacle(map, row, col, obs_row, obs_col)
    return map[row]:sub(col, col) == "#" or (row == obs_row and col == obs_col)
end

local function is_exit_map(map, row, col)
    return row > #map or row < 1 or col > #map[1] or col < 1
end

local function guard_step(map, start_row, start_col, obs_set, loop_pos_set, dir_i, row, col, obs_row, obs_col, do_find_loop)
    -- mark as visited
    if do_find_loop then
        local loop_pos_key = row .. "," .. col .. "," .. dir_i
        loop_pos_set[loop_pos_key] = true
    end

    local dir = DIRS[dir_i]
    local next_row = row + dir[1]
    local next_col = col + dir[2]

    -- exit the map
    if is_exit_map(map, next_row, next_col) then
        if do_find_loop then return false else return obs_set end
    end

    -- obstacle? Change direction, try again
    if is_obstacle(map, next_row, next_col, obs_row, obs_col) then
        local next_dir_i = change_dir(dir_i)
        return guard_step(map, start_row, start_col, obs_set, loop_pos_set,
                          next_dir_i, row, col,
                          obs_row, obs_col, do_find_loop)
    end

    -- install obstacle, kick off the loop check
    if not do_find_loop then
        local new_loop_pos_set = {}
        local new_obs_row = next_row
        local new_obs_col = next_col

        local is_loop = guard_step(map, start_row, start_col, obs_set, new_loop_pos_set,
                                   UP, start_row, start_col,
                                   new_obs_row, new_obs_col, true)
        if is_loop then
            local obs_key = new_obs_row .. "," .. new_obs_col
            obs_set[obs_key] = true
        end
    end

    -- loop?
    local loop_pos_key = next_row .. "," .. next_col .. "," .. dir_i
    if do_find_loop and loop_pos_set[loop_pos_key] then
        return true
    end

    return guard_step(map, start_row, start_col, obs_set, loop_pos_set,
                      dir_i, next_row, next_col,
                      obs_row, obs_col, do_find_loop)
end

-- do
--     local map = {
--         "....#.....",
--         ".........#",
--         "..........",
--         "..#.......",
--         ".......#..",
--         "..........",
--         ".#..^.....",
--         "........#.",
--         "#.........",
--         "......#..."
--     }

--     local row, col = find_guard(map)
--     local dir_i = UP
--     assert(row == 7)
--     assert(col == 5)
--     local pos_set = {}
--     local loop_pos_set = {}
--     local obs = {}
--     guard_step(map, row, col, obs, pos_set, loop_pos_set, dir_i, row, col, nil, nil, false)
--     local obs_num = 0; for _ in pairs(obs) do obs_num = obs_num + 1 end
--     assert(obs_num == 6, obs_num)
-- end

do
    local map = {}
    local file = io.open("input.txt", "r")

    for line in file:lines() do
        table.insert(map, line)
    end
    file:close()

    assert(#map[1] == 130)
    assert(#map == 130)

    local row, col = find_guard(map)
    assert(row == 46)
    assert(col == 43)

    local loop_pos_set = {}
    local obs = {}
    guard_step(map, row, col, obs, loop_pos_set, UP, row, col, nil, nil, false)
    local obs_num = 0; for _ in pairs(obs) do obs_num = obs_num + 1 end
    assert(obs_num == 1503)
end
