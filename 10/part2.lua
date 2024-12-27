local aoc = require "aoc"

aoc.PRINT = false
local mayprint = aoc.mayprint

local tins = aoc.tins
local trem = aoc.trem


local function pos_key(pos)
    return pos.r .. "," .. pos.c
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

local function up(pos) return {r = pos.r - 1, c = pos.c} end
local function down(pos) return {r = pos.r + 1, c = pos.c} end
local function left(pos) return {r = pos.r, c = pos.c - 1} end
local function right(pos) return {r = pos.r, c = pos.c + 1} end

local function walk_path(map, spos)
    assert(map[pos_key(spos)])

    local queue = {spos}
    local score = 0
    while #queue > 0 do
        local pos = trem(queue)
        local pos_height = map[pos_key(pos)]
        if pos_height == 9 then score = score + 1 end

        for _, next_pos in ipairs {up(pos), right(pos), down(pos), left(pos)} do
            local next_height = map[pos_key(next_pos)]
            if next_height and (next_height - pos_height == 1) then
                tins(queue, next_pos)
            end
        end
    end

    return score
end

do
    local lines = aoc.flines("input.txt")
    local map = mappify(lines)

    local score = 0
    for _, head in ipairs(find_heads(map))  do
        score = score + walk_path(map, head)
    end
    assert(score == 1786, score)
end
