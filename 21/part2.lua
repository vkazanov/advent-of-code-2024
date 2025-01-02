local aoc = require "aoc"

local Vec = aoc.Vec

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

local vec_to_ch = {
    ["<"] = aoc.LEFT, [">"] = aoc.RIGHT,
    ["^"] = aoc.UP, ["v"] = aoc.DOWN,
}

local function translate(codes, current_table, control_table, movement_cache)
    local control_chs = {}
    local dead_pos = current_table["X"]

    local prev_ch = "A"
    for _, ch in ipairs(codes) do
        local pos = current_table[prev_ch]
        local tar = current_table[ch]

        local key = prev_ch .. "->" .. ch
        local new_control_chs = movement_cache[key]
        if new_control_chs then
            goto next_char
        else
            new_control_chs = {}
        end

        do
            local diff = tar - pos
            while diff ~= Vec { 0, 0 } do
                local pos_diff = Vec{0, 0}
                local control_ch, ch_num

                -- diagonal movements
                if diff.y ~= 0 and diff.x ~= 0 then
                    -- dead key on the same horizontal line. Move vertically first.
                    if (dead_pos.y == pos.y) and (tar.x == dead_pos.x) then
                        goto vertical
                    end

                    -- dead key on the same vertical line . Move horizontally first.
                    if (dead_pos.x == pos.x) and (tar.y == dead_pos.y) then
                        goto horizontal
                    end

                    -- find the shortest movement (vert vs hotizontal)
                    do
                        local prev_pos = control_table[(#new_control_chs == 0) and "A"
                            or new_control_chs[#new_control_chs]]

                        local hori_pos = control_table[(diff.x < 0) and "<" or ">"]
                        local vert_pos = control_table[(diff.y < 0) and "^" or "v"]
                        local hori_dist = (hori_pos - prev_pos):manhattan_len()
                        local vert_dist = (vert_pos - prev_pos):manhattan_len()
                        if hori_dist <= vert_dist then
                            goto vertical
                        else
                            goto horizontal
                        end
                    end
                end

                ::horizontal::
                if diff.x ~= 0 then
                    control_ch = (diff.x < 0) and "<" or ">"
                    ch_num = math.abs(diff.x)
                    goto do_move
                end

                ::vertical::
                if diff.y ~= 0 then
                    control_ch = (diff.y < 0) and "^" or "v"
                    ch_num = math.abs(diff.y)
                    goto do_move
                end

                ::do_move::
                for _ = 1, ch_num do
                    tins(new_control_chs, control_ch)
                    pos_diff = pos_diff + vec_to_ch[control_ch]
                end
                pos = pos + pos_diff
                diff = tar - pos
            end

            tins(new_control_chs, "A")
        end

        movement_cache[key] = new_control_chs

        ::next_char::
        for _, v in ipairs(new_control_chs) do tins(control_chs, v) end
        prev_ch = ch
    end

    return control_chs
end

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

    local keypad_codes = translate(numpad_codes, numpad_to_pos, keypad_to_pos, {})

    local movement_cache = {}
    for i = 1, 25 do
        keypad_codes = translate(keypad_codes, keypad_to_pos, keypad_to_pos, movement_cache)
        print(i, #keypad_codes)
        -- print(i, #keypad_codes, tcon(keypad_codes))
    end
    -- print(tcon(keypad_codes))
    res = res + #keypad_codes * num
end
assert(res == 157908, res)
