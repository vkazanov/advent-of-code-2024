local aoc = require "aoc"

aoc.PRINT = false
local mayprint = aoc.mayprint

local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem

-- TODO: needs a Vec to simplify usage
-- TODO: move to utils

local function pos_key(pos)
    return pos.r .. "," .. pos.c
end

local function printpos(pos)
    if not aoc.PRINT then return end
    print(pos_key(pos))
end

local function mappify(lines)
  local map = {}
  local w = 1
  local r = 0
  for line in lines do
    r = r + 1
    local c = 0
    for ch in line:gmatch(".") do
      c = c + 1
      map[pos_key{r=r, c=c}] = tonumber(ch) or -1
    end
    w = math.max(w, c)
  end
  map.dim = {width=w, height=r}
  return map
end

local function printmap(map)
    if not aoc.PRINT then return end
    print(map.dim.height .. "/" .. map.dim.width)
    for r = 1, map.dim.height do
        for c = 1, map.dim.width do
            local ch = map[pos_key{r=r, c=c}]
            io.write(ch >= 0 and ch or ".")
        end
        io.write("\n")
    end
end

local function find_heads(map)
    local heads = {}
    for c = 1, map.dim.width do
        for r = 1, map.dim.height do
            if map[r .. "," .. c] == 0 then
                mayprint("head: " .. r .. "," .. c)
                tins(heads, {r=r, c=c})
            end
        end
    end
    return heads
end

local function up(pos)
    return {r = pos.r - 1, c = pos.c}
end

local function down(pos)
    return {r = pos.r + 1, c = pos.c}
end

local function left(pos)
    return {r = pos.r, c = pos.c - 1}
end

local function right(pos)
    return {r = pos.r, c = pos.c + 1}
end

local function walk_path(map, pos)
    -- left map?!
    assert(map[pos_key(pos)])

    -- printpos(pos)

    local this_height = map[pos_key(pos)]
    if this_height == 9 then
        mayprint("score 1 at " .. pos_key(pos))
        return 1
    end

    -- diff check
    local score = 0
    for _, next_pos in ipairs {up(pos), right(pos), down(pos), left(pos)} do
        local next_height = map[pos_key(next_pos)]
        if not next_height then goto continue end

        local diff_height = next_height - this_height
        if diff_height ~= 1 then goto continue end

        score = score + walk_path(map, next_pos)
        ::continue::
    end

    return score
end

do
    local example = [[
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
]]
    local map = mappify(example:gmatch("[^\n]+"))
    mayprint(example)
    printmap(map)

    local heads = find_heads(map)
    assert(#heads == 9)

    local score = 0
    for _, head in ipairs(heads)  do
        score = score + walk_path(map, head)
    end
    assert(score == 81)
end

do
    aoc.PRINT = false
    local lines = aoc.flines("input.txt")
    local map = mappify(lines)
    printmap(map)

    local heads = find_heads(map)
    local score = 0
    for _, head in ipairs(heads)  do
        score = score + walk_path(map, head)
    end
    assert(score == 1786)
end
