local aoc = require "aoc"

aoc.PRINT = false
local mayprint = aoc.mayprint

local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local r
local function robot_find(ch, x, y)
    if ch == "@" then r = aoc.vec { x, y }; return "@", "." end
    if ch == "#" then return "#", "#" end
    if ch == "." then return ".", "." end
    if ch == "O" then return "[", "]" end
    assert(false)
end

local function can_push(m, pos, dir)
    mayprint("can_push? " .. tostring(pos) .. m[pos] .. " to " .. tostring(pos + dir) .. tostring(m[pos + dir]))

    if m[pos] == "." then return true end

    if m[pos] == "#" then return false end

    if m[pos] == "]" then
        if dir == aoc.RIGHT or dir == aoc.LEFT then return can_push(m, pos + dir, dir) end
        return can_push(m, pos + dir, dir) and can_push(m, pos + aoc.LEFT + dir, dir)
    end

    if m[pos] == "[" then
        if dir == aoc.RIGHT or dir == aoc.LEFT then return can_push(m, pos + dir, dir) end
        return can_push(m, pos + dir, dir) and can_push(m, pos + aoc.RIGHT + dir, dir)
    end

    assert(false, "can't check " .. tostring(pos) .. ":" .. m[pos])
end

local function push(m, pos, dir)
    mayprint("push: " .. tostring(pos) .. m[pos] .. " to " .. tostring(pos + dir))
    local ch = m[pos]

    if ch == "." then
        return true, pos
    end

    if ch == "]" then
        if can_push(m, pos, dir) then
            if dir == aoc.RIGHT or dir == aoc.LEFT then
                push(m, pos + dir, dir)
                m[pos], m[pos + dir] = m[pos + dir], m[pos]
            else
                push(m, pos + dir, dir)
                push(m, pos + aoc.LEFT + dir, dir)
                m[pos], m[pos + dir] = m[pos + dir], m[pos]
                m[pos + aoc.LEFT], m[pos + aoc.LEFT + dir] = m[pos + aoc.LEFT + dir], m[pos + aoc.LEFT]
            end
            return true, pos + dir
        else
            return false, pos
        end
    end

    if ch == "[" then
        if can_push(m, pos, dir) then
            if dir == aoc.RIGHT or dir == aoc.LEFT then
                push(m, pos + dir, dir)
                m[pos], m[pos + dir] = m[pos + dir], m[pos]
            else
                push(m, pos + dir, dir)
                push(m, pos + aoc.RIGHT + dir, dir)
                m[pos], m[pos + dir] = m[pos + dir], m[pos]
                m[pos + aoc.RIGHT], m[pos + aoc.RIGHT + dir] = m[pos + aoc.RIGHT + dir], m[pos + aoc.RIGHT]
            end
            return true, pos + dir
        else
            return false, pos
        end
    end

    if ch == "@" then
        if can_push(m, pos + dir, dir) then
            push(m, pos + dir, dir)
            m[pos], m[pos + dir] = m[pos + dir], m[pos]
            return true, pos + dir
        else
            return false, pos
        end
    end

    assert(false, "can't push  " .. tostring(pos) .. ":" .. m[pos])
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
    local map = aoc.mappify_double(test_map:gmatch("([^\n]+)"), robot_find)
    map:print()

    for line in test_moves:gmatch("([^\n]+)") do
        for ch in line:gmatch(".") do
            -- mayprint(ch)
            _, r = push(map, r, ch_to_dir[ch])
            -- map:print()
            -- aoc.sleep(0.3)
        end
    end
    -- map:print()

    local result = 0
    map:apply(function(pos, tile)
        if tile == "[" then result = result + 100 * pos.y + pos.x end
        return
    end)
    assert(result == 9021)

end

do
    local map = aoc.mappify_double(aoc.fline():gmatch("(#[^\n]+)"), robot_find)
    map:print()

    for line in aoc.fline():gmatch("([^#][^\n]+)") do
        for ch in line:gmatch("[<>^v]") do
            -- mayprint(ch)
            _, r = push(map, r, ch_to_dir[ch])
            -- map:print()
            -- aoc.sleep(0.3)
        end
    end
    map:print()

    local result = 0
    map:apply(function(pos, tile)
        if tile == "[" then result = result + 100 * pos.y + pos.x end
        return
    end)
    print(result)

end


-- do
--     local map = aoc.mappify(aoc.fline():gmatch("(#[^\n]+)"), robot_find)
--     map:print()

--     for line in aoc.fline():gmatch("([^#][^\n]+)") do
--         for ch in line:gmatch("[<>^v]") do
--             _, r = push(map, r, ch_to_dir[ch])
--         end
--     end
--     map:print()

--     local result = 0
--     map:apply(function(pos, tile)
--         if tile == "O" then result = result + 100 * pos.y + pos.x end
--         return
--     end)

--     print(result)
-- end
