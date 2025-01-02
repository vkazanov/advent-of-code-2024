local aoc = require "aoc"
local deque = require "deque"

local function mix(num, secret) return num ~ secret end
local function prune(secret) return secret % 16777216 end
local function next_secret(secret)
    secret = prune(mix(secret << 6, secret))
    secret = prune(mix(secret >> 5, secret))
    secret = prune(mix(secret << 11, secret))
    return secret, secret % 10
end

local seq2count = {}
for l in aoc.flines() do

    local seq = deque.new()
    local seq2seen = {}

    local secret = tonumber(l)
    local price = secret % 10
    for _ = 1, 2000 do
        local new_secret, new_price = next_secret(secret)
        seq.tail = seq.tail + 1
        seq[seq.tail] = new_price - price
        local tail, head = seq.tail, seq.head
        if tail - head >= 4 then
            local key = seq[tail] + 100*seq[tail - 1] + 10000*seq[tail - 2] + 1000000*seq[tail - 3]
            if not seq2seen[key] then
                seq2seen[key] = true
                seq2count[key] = (seq2count[key] or 0) + new_price
            end
        end
        secret, price = new_secret, new_price
    end
end

local max_count = 0
for _, count in pairs(seq2count) do
    if count > max_count then max_count = count end
end

assert(max_count == 2042, max_count)
