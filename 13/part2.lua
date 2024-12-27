local aoc = require "aoc"

aoc.PRINT = false

local pos = aoc.pos

local OFF = 10000000000000
local A_TOKS = 3
local B_TOKS = 1
local TOO_HIGH = OFF * B_TOKS + OFF * A_TOKS + OFF -- impossible price

local function play(t, a_v, b_v)

    local gcd = aoc.gcd(a_v.r, b_v.r)
    if t.r % gcd > 0 then
        return TOO_HIGH
    end

    gcd = aoc.gcd(a_v.c, b_v.c)
    if t.c % gcd > 0 then
        return TOO_HIGH
    end

    local a = t.r * (b_v.r - b_v.c) - b_v.r * (t.r - t.c)
    a = a / (a_v.r * (b_v.r - b_v.c) - b_v.r * (a_v.r - a_v.c))
    local b = (t.r - a * a_v.r) / b_v.r

    if a ~= math.floor(a) then return TOO_HIGH end
    if b ~= math.floor(b) then return TOO_HIGH end

    return a * A_TOKS + b * B_TOKS
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
        local target = pos { tonumber(target_r) + OFF, tonumber(target_c) + OFF}

        local price = play(target, a_diff, b_diff)
        total_min_price = total_min_price + (price ~= TOO_HIGH and price or 0)

        if not lines() then break end
    end

    assert(total_min_price == 73267584326867)
end
