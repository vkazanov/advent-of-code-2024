local aoc = require "aoc"

local function mix(num, secret)
    return num ~ secret
end

local function prune(secret)
    return secret % 16777216
end

local function next(secret)
    local a = secret << 6
    secret = prune(mix(a, secret))

    local b = secret >> 5
    secret = prune(mix(b, secret))

    local c = secret << 11
    secret = prune(mix(c, secret))

    return secret
end

local res = 0
for l in aoc.flines() do
    local secret = tonumber(l)
    for _ = 1, 2000 do secret = next(secret) end
    res = res + secret
end
assert(res == 17960270302, res)
