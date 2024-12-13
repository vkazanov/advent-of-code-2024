local aoc = require "aoc"

aoc.PRINT = false
local mayprint = aoc.mayprint

local pos = aoc.pos
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local A_TOKS = 3
local B_TOKS = 1
local A_STEPS = 100
local B_STEPS = 100
local TOO_HIGH = A_TOKS * A_STEPS + B_TOKS * B_STEPS + 1 -- impossible price

local function play(target, a_diff, b_diff,
                    paid, cache, a_steps, b_steps)
    if not paid then paid = 0 end
    if not cache then cache = {} end
    if not a_steps then a_steps = A_STEPS; b_steps = B_STEPS end

    if target == pos { 0, 0 } then
        mayprint("SOL: " .. a_steps .. "/" .. b_steps)
        return paid
    end
    if target.r < 0 or target.c < 0 then return TOO_HIGH end
    if a_steps <= 0 then return TOO_HIGH end
    if b_steps <= 0 then return TOO_HIGH end

    if cache[target] then return cache[target] end

    local price_a = play(target - a_diff, a_diff, b_diff, paid + A_TOKS, cache, a_steps - 1, b_steps)
    local price_b = play(target - b_diff, a_diff, b_diff, paid + B_TOKS, cache, a_steps, b_steps - 1)
    local result = math.min(price_a, price_b)

    cache[target] = result

    return result
end

do
    local a_diff = pos { 10, 10 }
    local b_diff = pos { 11, 11 }
    local target = pos { 3, 3 }

    assert(play(target, a_diff, b_diff) == TOO_HIGH)
end

do
    local a_diff = pos { 1, 1 }
    local b_diff = pos { 100, 100 }
    local target = pos { 3, 3 }

    assert(play(target, a_diff, b_diff) == 9)
end

do
    local a_diff = pos { 0, 1 }
    local b_diff = pos { 0, 100 }
    local target = pos { 0, 103 }

    local price = play(target, a_diff, b_diff)
    assert(price == 10, price)
end

do
    aoc.PRINT = false

    local a_diff = pos { 1, 0 }
    local b_diff = pos { 100, 0 }
    local target = pos { 103, 0 }

    local price = play(target, a_diff, b_diff)
    assert(price == 10, price)
end

do

    local a_diff = pos { 1, 0 }
    local b_diff = pos { 0, 1 }
    local target = pos { 100, 0 }

    local price = play(target, a_diff, b_diff)
    assert(price ~= TOO_HIGH, "TOO HIGH")
    assert(price == 100*A_TOKS, price)
end

do

    local a_diff = pos { 1, 0 }
    local b_diff = pos { 0, 1 }
    local target = pos { 0, 100 }

    local price = play(target, a_diff, b_diff)
    assert(price ~= TOO_HIGH, "TOO HIGH")
    assert(price == 100*B_TOKS, price)
end

do
    local a_diff = pos { 1, 0 }
    local b_diff = pos { 0, 3 }
    local target = pos { 3, 99 }

    local price = play(target, a_diff, b_diff)
    assert(price ~= TOO_HIGH, "TOO HIGH")
    assert(price == 3*A_TOKS + 33*B_TOKS, price)
end

do -- sol
    aoc.PRINT = true

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

do
    aoc.PRINT = true

    local total_min_price = 0
    local lines = aoc.flines()
    while true do
        local line_a = lines()
        local line_b = lines()
        local line_target = lines()
        assert(line_a and line_b and line_target)

        local a_r, a_c = line_a:match("X%+(%d+)%s*,%s*Y%+(%d+)")
        local a_diff = pos {tonumber(a_r), tonumber(a_c)}

        local b_r, b_c = line_b:match("X%+(%d+)%s*,%s*Y%+(%d+)")
        local b_diff = pos { tonumber(b_r), tonumber(b_c) }

        local target_r, target_c = line_target:match("X=(%d+)%s*,%s*Y=(%d+)")
        local target = pos { tonumber(target_r), tonumber(target_c) }

        local price = play(target, a_diff, b_diff)
        total_min_price = total_min_price + (price ~= TOO_HIGH and price or 0)

        if not lines() then break end
    end

    assert(total_min_price == 39996)
end
