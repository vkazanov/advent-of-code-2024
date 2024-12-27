local aoc = require "aoc"

local pos = aoc.pos

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
