local aoc = require "aoc"

local Vec = aoc.Vec

local tins = table.insert
local tcon = table.concat
local trem = table.remove
local tmov = table.move
local tunp = table.unpack

local function pos_key(pos, dir)
    return tostring(pos) .. ":" .. tostring(dir)
end

local function step_obs(pos, dir, x2obs, y2obs, seen)
    -- loop check
    if not seen then seen = {} end
    if seen[pos_key(pos, dir)] then
        return true
    else
        seen[pos_key(pos, dir)] = true
    end

    -- find the next obstacle
    local line_obs
    if dir == aoc.UP or dir == aoc.DOWN then
        line_obs = x2obs[pos.x]
    elseif dir == aoc.LEFT or dir == aoc.RIGHT then
        line_obs = y2obs[pos.y]
    end

    local obs
    local obs_dist = math.maxinteger
    for _, o in pairs(line_obs) do
        local o_dist = math.maxinteger
        if dir == aoc.UP then
            if o.y > pos.y then goto skip_o end
            o_dist = math.abs(o.y - pos.y)
        elseif dir == aoc.DOWN then
            if o.y < pos.y then goto skip_o end
            o_dist = math.abs(o.y - pos.y)
        elseif dir == aoc.RIGHT then
            if o.x < pos.x then goto skip_o end
            o_dist = math.abs(o.x - pos.x)
        elseif dir == aoc.LEFT then
            if o.x > pos.x then goto skip_o end
            o_dist = math.abs(o.x - pos.x)
        end

        if o_dist < obs_dist then
            obs = o
            obs_dist = o_dist
        end

        ::skip_o::
    end

    -- no obstacle found? left the map, so no loop
    if not obs then return false end

    -- find the next position
    local target_pos, target_dir
    if dir == aoc.UP then
        target_pos = obs + aoc.DOWN
    elseif dir == aoc.DOWN then
        target_pos = obs + aoc.UP
    elseif dir == aoc.RIGHT then
        target_pos = obs + aoc.LEFT
    elseif dir == aoc.LEFT then
        target_pos = obs + aoc.RIGHT
    end
    target_dir = dir:rot_clock()

    return step_obs(target_pos, target_dir, x2obs, y2obs, seen)
end

local function step(m, pos, dir, x2obs, y2obs, loop_set)
    local next_pos = pos + dir
    local next_dir = dir

    -- out of boundaries
    if not m[next_pos] then return loop_set end

    -- obstacle? turn right
    if m[next_pos] == "#" then
        next_pos = pos
        next_dir = next_dir:rot_clock()
    end

    -- add an obstacle, check if a loop
    do
        if not x2obs[next_pos.x] then x2obs[next_pos.x] = {} end
        if not y2obs[next_pos.y] then y2obs[next_pos.y] = {} end
	tins(x2obs[next_pos.x], next_pos)
	tins(y2obs[next_pos.y], next_pos)

        if step_obs(pos, dir, x2obs, y2obs) then
            loop_set[pos] = true
        end

	trem(x2obs[next_pos.x])
	trem(y2obs[next_pos.y])
    end

    -- do the step
    return step(m, next_pos, next_dir, x2obs, y2obs, loop_set)
end

local flines_iter = aoc.flines()

local spos, sdir, obstacles = nil, aoc.UP, {}
local m = aoc.mappify_lines(flines_iter,
                            function(ch, pos)
        if ch == "^" then
            spos = pos
            ch = "."
        elseif ch == "#" then
            tins(obstacles, pos)
        end
        return ch
end)
assert(spos and sdir and #obstacles > 0)

local x_obstacles, y_obstacles = {}, {}
for _, o in pairs(obstacles) do
    if not x_obstacles[o.x] then x_obstacles[o.x] = {} end
    if not y_obstacles[o.y] then y_obstacles[o.y] = {} end
    tins(x_obstacles[o.x], o)
    tins(y_obstacles[o.y], o)
end

local loop_set = step(m, spos, sdir, x_obstacles, y_obstacles, {})
local loop_count = 0
for _ in pairs(loop_set) do loop_count = loop_count + 1 end
print(loop_count)
