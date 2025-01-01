local aoc = require "aoc"
aoc.PRINT = false
local mayprint = aoc.mayprint

local Vec = aoc.Vec

local ssplit = aoc.str_split
local arreq = aoc.arr_eq
local permute = aoc.permutations

local tins = table.insert
local tcon = table.concat
local trem = table.remove
local tunp = table.unpack
local tpck = table.pack
local tsrt = table.sort

-- +---+---+---+
-- | 7 | 8 | 9 |
-- +---+---+---+
-- | 4 | 5 | 6 |
-- +---+---+---+
-- | 1 | 2 | 3 |
-- +---+---+---+
--     | 0 | A |
--     +---+---+

--     +---+---+
--     | ^ | A |
-- +---+---+---+
-- | < | v | > |
-- +---+---+---+

local numpad_to_pos = {
    ["7"] = Vec{0, 0}, ["8"] = Vec{1, 0}, ["9"] = Vec{2, 0},
    ["4"] = Vec{0, 1}, ["5"] = Vec{1, 1}, ["6"] = Vec{2, 1},
    ["1"] = Vec{0, 2}, ["2"] = Vec{1, 2}, ["3"] = Vec{2, 2},
    ["X"] = Vec{0, 3}, ["0"] = Vec{1, 3}, ["A"] = Vec{2, 3},
}

local keypad_to_pos = {
    ["X"] = Vec{0, 0}, ["^"] = Vec{1, 0}, ["A"] = Vec{2, 0},
    ["<"] = Vec{0, 1}, ["v"] = Vec{1, 1}, [">"] = Vec{2, 1},
}

local function translate(init_ch, codes, trans_table, control_table)
    local res = {}

    local dead_pos = trans_table["X"]

    local pos_ch = init_ch
    for _, ch in ipairs(codes) do
        local pos = trans_table[pos_ch]
        local tar = trans_table[ch]

        local diff = tar - pos
        while diff ~= Vec { 0, 0 } do
            local pos_diff = Vec{0, 0}

            -- diagonal movements
            if diff.y ~= 0 and diff.x ~= 0 then
                -- dead key on the same horizontal line. Move vertically first.
                if (dead_pos.y == pos.y) and (pos.x + diff.x == dead_pos.x) then
                    goto vertical
                end

                -- dead key on the same vertical line . Move horizontally first.
                if (dead_pos.x == pos.x) and (pos.y + diff.y == dead_pos.y) then
                    goto horizontal
                end

                -- find the shortest movement (vert vs hotizontal)
                do
                    local prev_ch = (#res == 0) and "A" or res[#res]
                    local prev_pos = control_table[prev_ch]

                    local hori_ch = (diff.x < 0) and "<" or ">"
                    local hori_pos = control_table[hori_ch]
                    local hori_dist = (hori_pos - prev_pos):manhattan_len()

                    local vert_ch = (diff.y < 0) and "^" or "v"
                    local vert_pos = control_table[vert_ch]
                    local vert_dist = (vert_pos - prev_pos):manhattan_len()
                    if hori_dist <= vert_dist then
                        goto vertical
                    else
                        goto horizontal
                    end
                end

                -- do a horizontal move, the remainder is vertical
                ::horizontal::
                if diff.x < 0 then
                    for _ = 1, math.abs(diff.x) do
                        tins(res, "<")
                        pos_diff = pos_diff + aoc.LEFT
                    end
                elseif diff.x > 0 then
                    for _ = 1, math.abs(diff.x) do
                        tins(res, ">")
                        pos_diff = pos_diff + aoc.RIGHT
                    end
                else assert(false) end
                goto next

                -- do a vertical move, the remainder is horizontal
                ::vertical::
                if diff.y < 0 then
                    for _ = 1, math.abs(diff.y) do
                        tins(res, "^")
                        pos_diff = pos_diff + aoc.UP
                    end
                elseif diff.y > 0 then
                    for _ = 1, math.abs(diff.y) do
                        tins(res, "v")
                        pos_diff = pos_diff + aoc.DOWN
                    end
                else assert(false) end
                goto next
            end

            -- straight horizontal movements
            if (diff.y == 0) and (diff.x ~= 0) then
                if diff.x < 0 then
                    for _ = 1, math.abs(diff.x) do
                        tins(res, "<")
                        pos_diff = pos_diff + aoc.LEFT
                    end
                elseif diff.x > 0 then
                    for _ = 1, math.abs(diff.x) do
                        tins(res, ">")
                        pos_diff = pos_diff + aoc.RIGHT
                    end
                end
                goto next
            end

            -- straight vertical movements
            if (diff.y ~= 0) and (diff.x == 0) then
                if diff.y < 0 then
                    for _ = 1, math.abs(diff.y) do
                        tins(res, "^")
                        pos_diff = pos_diff + aoc.UP
                    end
                elseif diff.y > 0 then
                    for _ = 1, math.abs(diff.y) do
                        tins(res, "v")
                        pos_diff = pos_diff + aoc.DOWN
                    end
                end
                goto next
            end

            ::next::
            pos = pos + pos_diff
            diff = tar - pos
        end

        tins(res, "A")
        pos_ch = ch
    end

    return res
end

-- local input = {
--     ["029A"] = "<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A", -- 68
--     ["980A"] = "<v<A>>^AAAvA^A<vA<AA>>^AvAA<^A>A<v<A>A>^AAAvA<^A>A<vA>^A<A>A", -- 60
--     ["179A"] = "<v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A", -- 68
--     ["456A"] = "<v<A>>^AA<vA<A>>^AAvAA<^A>A<vA>^A<A>A<vA>^A<A>A<v<A>A>^AAvA<^A>A", -- 64
--     ["379A"] = "<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A", -- 64
-- }

-- local input = {
--     ["029A"] = 29,
--     ["980A"] = 980,
--     ["179A"] = 179,
--     ["456A"] = 456,
--     ["379A"] = 379
-- }

local input = {
    ["341A"] = 341,
    ["803A"] = 803,
    ["149A"] = 149,
    ["683A"] = 683,
    ["208A"] = 208,
}

local res = 0
for code, num in pairs(input) do
    local numpad_codes = {}
    for c in code:gmatch(".") do tins(numpad_codes, c) end
    print("numpad: ", tcon(numpad_codes))
    local keypad1_codes = translate("A", numpad_codes, numpad_to_pos, keypad_to_pos)
    print("keypad1: ", tcon(keypad1_codes))
    local keypad2_codes = translate("A", keypad1_codes, keypad_to_pos, keypad_to_pos)
    print("keypad2: ", tcon(keypad2_codes))
    local final_codes = translate("A", keypad2_codes, keypad_to_pos, keypad_to_pos)
    print("keypad3:", tcon(final_codes), #final_codes)
    res = res + #final_codes * num
end

assert(res == 157908, res)
