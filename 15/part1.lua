local aoc = require "aoc"

aoc.PRINT = true
local mayprint = aoc.mayprint

local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local r
local function robot_find(ch, x, y)
    if ch == "@" then r = aoc.vec { x, y } end
    return ch
end

local function push(m, pos, dir)
    local tar = pos + dir
    local tar_ch = m[tar]

    if tar_ch == "#" then return false, pos end

    if tar_ch  == "." then
        m[tar], m[pos] = m[pos], m[tar]
        return true, tar
    end

    if tar_ch == "O" or tar_ch == "@" then
        if push(m, tar, dir) then
            m[tar], m[pos] = m[pos], m[tar]
            return true, tar
        else
            return false, pos
        end
    end

    assert(false, "unknown tile at " .. tostring(tar) .. ":" .. tar_ch)
end

local ch_to_dir = {
    ["<"] = aoc.LEFT,
    [">"] = aoc.RIGHT,
    ["^"] = aoc.UP,
    ["v"] = aoc.DOWN,
}

do
    local map = aoc.mappify(aoc.fline():gmatch("(#[^\n]+)"), robot_find)
    for line in aoc.fline():gmatch("([^#][^\n]+)") do
        for ch in line:gmatch("[<>^v]") do
            _, r = push(map, r, ch_to_dir[ch])
        end
    end

    local result = 0
    map:apply(function(pos, tile)
        if tile == "O" then result = result + 100 * pos.y + pos.x end
        return
    end)

    assert(result == 1516281)
end
