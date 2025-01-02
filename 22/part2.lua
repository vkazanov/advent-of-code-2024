local aoc = require "aoc"
local tcon = table.concat
local deque = require "deque"

local function mix(num, secret)
    return num ~ secret
end

local function prune(secret)
    return secret % 16777216
end

local function next_secret(secret)
    local a = secret << 6
    secret = prune(mix(a, secret))

    local b = secret >> 5
    secret = prune(mix(b, secret))

    local c = secret << 11
    secret = prune(mix(c, secret))

    return secret, secret % 10
end

local global_seq2count = {}
for l in aoc.flines() do

    local seq = deque.new()

    local seq2count = {}

    local secret = tonumber(l)
    local price = secret % 10
    for _ = 1, 2000 do
        local new_secret, new_price = next_secret(secret)
        local new_diff = new_price - price

        seq:push_right(new_diff)
        if seq:length() > 4 then seq:pop_left() end

        if seq:length() == 4 then
            local key = tcon(seq:contents(), ",")
            if not seq2count[key] then seq2count[key] = new_price end
        end

        secret, price = new_secret, new_price
    end

    for key, count in pairs(seq2count) do
        global_seq2count[key] = (global_seq2count[key] or 0) + count
    end
end

local max_count = 0
for _, count in pairs(global_seq2count) do
    if count > max_count then max_count = count end
end

assert(max_count == 2042, max_count)
