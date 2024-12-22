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
    ["7"] = Vec{0, 0},
    ["8"] = Vec{1, 0},
    ["9"] = Vec{2, 0},
    ["4"] = Vec{0, 1},
    ["5"] = Vec{1, 1},
    ["6"] = Vec{2, 1},
    ["1"] = Vec{0, 2},
    ["2"] = Vec{1, 2},
    ["3"] = Vec{2, 2},
    ["0"] = Vec{1, 3},
    ["A"] = Vec{2, 3},
}

local keypad_to_pos = {
    ["^"] = Vec{1, 0},
    ["A"] = Vec{2, 0},
    ["<"] = Vec{0, 1},
    ["v"] = Vec{1, 1},
    [">"] = Vec{2, 1},
}

local function translate(init, codes, trans_table)
    local res = {}

    local pos = init
    for _, c in ipairs(codes) do
        local p_v = trans_table[pos]
        local t_v = trans_table[c]
        local diff_v = t_v - p_v
        print(pos, c, diff_v)

        local moves = {}
        for _ = 0, math.abs(diff_v.y) - 1 do
            if diff_v.y < 0 then tins(moves, "^") end
            if diff_v.y > 0 then tins(moves, "v") end
        end

        for _ = 0, math.abs(diff_v.x) - 1 do
            if diff_v.x < 0 then tins(moves, "<") end
            if diff_v.x > 0 then tins(moves, ">") end
        end

        -- TODO: check the empty button space

        tins(res, permute(moves))
        tins(res, "A")

        pos = c
    end

    return res
end

local function expand(variant_list)
    local res = {}
    for _, var in pairs(variant_list) do
        local new_res = {}
        if type(var) == "string" then
            print(var)
            if #res > 0 then
                for _, str in pairs(res) do
                    tins(new_res, str .. var)
                end

            else
                new_res = { var }
            end
        else -- list of variants
            if #res > 0 then
                print("[")
                for _, prm in pairs(var) do
                    print("  " .. tcon(prm))
                    for _, str in pairs(res) do
                        tins(new_res, str .. tcon(prm))
                    end
                end
                print("]")
            else
                print("[")
                for _, prm in pairs(var) do
                    print("  " .. tcon(prm))
                    tins(new_res, tcon(prm))
                end
                print("]")
            end
        end
        res = new_res
    end

    local function make_unique(str_list)
        local seen = {}
        local result = {}

        for _, str in ipairs(str_list) do
            if not seen[str] then
                seen[str] = true
                table.insert(result, str)
            end
        end

        return result
    end
    print("done expanding")
    return make_unique(res)
end

local function expand_table(table1, table2)
    for i = 1, #table2 do
        table.insert(table1, table2[i])
    end
end

local keypad1_codes = translate("A", { "0", "2", "9", "A" }, numpad_to_pos)
keypad1_codes = expand(keypad1_codes)
print(tcon(keypad1_codes, "\n"))

local keypad2_codes = {}
for _, codes in pairs(keypad1_codes) do
    print("translating: " .. codes)
    local translated = translate("A", aoc.str_to_arr(codes), keypad_to_pos)
    print("  expanding len=" .. tostring(#translated))
    local expanded = expand(translated)
    print("  " .. tcon(expanded, ", "))

    -- expand_table(keypad2_codes, expand(translate("A", aoc.str_to_arr(codes), keypad_to_pos)))
end
-- print(tcon(keypad2_codes, "\n"))

-- local input = {
--     ["029A"] = 29, -- 68
--     ["980A"] = 980, -- 60
--     ["179A"] = 179, -- 68
--     ["456A"] = 456, -- 64
--     ["379A"] = 379, -- 68
-- }

-- local res = 0
-- for code, num in pairs(input) do
--     local numpad_codes = {}
--     for c in code:gmatch(".") do tins(numpad_codes, c) end
--     print(tcon(numpad_codes))
--     local keypad1_codes = translate("A", numpad_codes, numpad_to_pos)
--     print(tcon(keypad1_codes))
--     local keypad2_codes = translate("A", keypad1_codes, keypad_to_pos)
--     print(tcon(keypad2_codes))
--     local final_codes = translate("A", keypad2_codes, keypad_to_pos)
--     print(tcon(final_codes))
--     print(#final_codes)
--     res = res + #final_codes * num
-- end
-- print(res)

-- for _, code_str in ipairs { "<A^A>^^AvvvA", "<A^A^>^AvvvA", "<A^A^^>AvvvA" } do
--     local codes = {}
--     for ch in code_str:gmatch(".") do tins(codes, ch) end
--     local keypad1_codes = translate("A", codes, keypad_to_pos)
--     print(code_str, tcon(keypad1_codes))
-- end

-- 160876 -- too high
