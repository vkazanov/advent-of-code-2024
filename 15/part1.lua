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

local test_map = [[
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########
]]

local test_moves = [[
<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
]]

do
    local map = aoc.mappify(test_map:gmatch("([^\n]+)"), robot_find)

    for line in test_moves:gmatch("([^\n]+)") do
        for ch in line:gmatch(".") do
            -- print(ch)
            _, r = push(map, r, ch_to_dir[ch])
            -- aoc.sleep(0.5)
        end
    end

    local result = 0
    map:apply(function(pos, tile)
        if tile == "O" then result = result + 100 * pos.y + pos.x end
        return
    end)

    assert(result == 10092)
end

do
    local map = aoc.mappify(aoc.fline():gmatch("(#[^\n]+)"), robot_find)
    map:print()

    for line in aoc.fline():gmatch("([^#][^\n]+)") do
        for ch in line:gmatch("[<>^v]") do
            _, r = push(map, r, ch_to_dir[ch])
        end
    end
    map:print()

    local result = 0
    map:apply(function(pos, tile)
        if tile == "O" then result = result + 100 * pos.y + pos.x end
        return
    end)

    assert(result == 1516281)
end
