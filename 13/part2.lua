local aoc = require "aoc"

aoc.PRINT = false
local mayprint = aoc.mayprint

local pos = aoc.pos
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local OFF = 10000000000000
local A_TOKS = 3
local B_TOKS = 1
local TOO_HIGH = OFF * B_TOKS + OFF * A_TOKS + OFF -- impossible price

local function play(target, a_v, b_v)

    print("target+ " .. tostring(target))

    local gcd = aoc.gcd(a_v.r, b_v.r)
    if target.r % gcd > 0 then
        mayprint("SKIP GCD 1" .. gcd)
        return TOO_HIGH
    end
    a_v.r = a_v.r / gcd
    b_v.r = b_v.r / gcd
    target.r = target.r / gcd

    gcd = aoc.gcd(a_v.c, b_v.c)
    if target.c % gcd > 0 then
        mayprint("SKIP GCD 2 " .. gcd)
        return TOO_HIGH
    end
    a_v.c = a_v.c / gcd
    b_v.c = b_v.c / gcd
    target.c = target.c / gcd

    print("target- " .. tostring(target))

    local a = 0
    local b
    while true do
        local r, c
        b = (target.r - target.c) - a * (a_v.r - a_v.c)
        b = b / (b_v.r - b_v.c)
        mayprint("check a=" .. a .. " b=" .. b)

        if b ~= math.floor(b) then
            mayprint("skip float " .. b )
            goto next
        end
        if b < 0 then
            mayprint("skip negative" .. b)
            goto next
        end

        r = a * a_v.r + b * b_v.r
        c = a * a_v.c + b * b_v.c

        if r > target.r then
            mayprint("too big 1 " .. r)
            return TOO_HIGH
        end

        if c > target.c then
            mayprint("too big 2 " .. c)
            return TOO_HIGH
        end

        if r ~= target.r then
            mayprint("skip 1")
            goto next
        end
        if c ~= target.c then
            mayprint("skip 2")
            goto next
        end

        -- got it
        break

        ::next::
        a = a + 1
    end

    return a * A_TOKS + b * B_TOKS
end

do -- sol
    local a_diff = pos { 94, 34 }
    local b_diff = pos { 22, 67 }
    local target = pos { 8400, 5400 }

    local price = play(target, a_diff, b_diff)
    assert(price ~= TOO_HIGH, "TOO HIGH")
    assert(price == 280, price)
end

do -- no sol
-- Button A: X+26, Y+66
-- Button B: X+67, Y+21
-- Prize: X=12748, Y=12176
    local a_diff = pos { 26, 66 }
    local b_diff = pos { 67, 21 }
    local target = pos { 12748, 12176 }

    local price = play(target, a_diff, b_diff)
    assert(price == TOO_HIGH, "NOT TOO HIGH")
end

do -- sol == 200
-- Button A: X+17, Y+86
-- Button B: X+84, Y+37
-- Prize: X=7870, Y=6450

    local a_diff = pos { 17, 86 }
    local b_diff = pos { 84, 37 }
    local target = pos { 7870, 6450 }

    local price = play(target, a_diff, b_diff)
    assert(price ~= TOO_HIGH, "TOO HIGH")
    assert(price == 200, price)
end

do -- no sol
-- Button A: X+69, Y+23
-- Button B: X+27, Y+71
-- Prize: X=18641, Y=10279
    local a_diff = pos { 69, 23 }
    local b_diff = pos { 27, 71 }
    local target = pos { 18641, 10279 }

    local price = play(target, a_diff, b_diff)
    assert(price == TOO_HIGH, "NOT TOO HIGH")
end

----- OFFSET

do
    -- aoc.PRINT = true
    local a_diff = pos { 94, 34 }
    local b_diff = pos { 22, 67 }
    local target = pos { 8400 + OFF, 5400  + OFF}

    local price = play(target, a_diff, b_diff)
    assert(price == TOO_HIGH)
end

-- do -- sol
--     local a_diff = pos { 26, 66 }
--     local b_diff = pos { 67, 21 }
--     local target = pos { 12748 + OFF, 12176 + OFF}

--     local price = play(target, a_diff, b_diff)
--     assert(price ~= TOO_HIGH)
-- end

-- do

--     local a_diff = pos { 17, 86 }
--     local b_diff = pos { 84, 37 }
--     local target = pos { 7870 + OFF, 6450 + OFF }

--     local price = play(target, a_diff, b_diff)
--     assert(price == TOO_HIGH)
-- end

-- do -- sol
--     local a_diff = pos { 69, 23 }
--     local b_diff = pos { 27, 71 }
--     local target = pos { 18641, 10279 }

--     local price = play(target, a_diff + OFF, b_diff + OFF)
--     assert(price ~= TOO_HIGH)
-- end

-- do

--     local total_min_price = 0
--     local lines = aoc.flines()
--     while true do
--         local line_a = lines()
--         local line_b = lines()
--         local line_target = lines()
--         assert(line_a and line_b and line_target)

--         local a_r, a_c = line_a:match("X%+(%d+)%s*,%s*Y%+(%d+)")
--         local a_diff = pos {tonumber(a_r), tonumber(a_c)}

--         local b_r, b_c = line_b:match("X%+(%d+)%s*,%s*Y%+(%d+)")
--         local b_diff = pos { tonumber(b_r), tonumber(b_c) }

--         local target_r, target_c = line_target:match("X=(%d+)%s*,%s*Y=(%d+)")
--         local target = pos { tonumber(target_r), tonumber(target_c) }

--         local price = play(target, a_diff, b_diff)
--         total_min_price = total_min_price + (price ~= TOO_HIGH and price or 0)

--         if not lines() then break end
--     end

--     print(total_min_price)
-- end
