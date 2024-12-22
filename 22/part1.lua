local aoc = require "aoc"
aoc.PRINT = false
local mayprint = aoc.mayprint

local Vec = aoc.Vec

local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local tins = table.insert
local tcon = table.concat
local trem = table.remove
local tunp = table.unpack
local tpck = table.pack
local tsrt = table.sort

-- TODO: go for it!

local function mix(num, secret)
    return num ~ secret
end

local function prune(secret)
    return secret % 16777216
end

local function next(secret)
    local a = secret << 6
    secret = mix(a, secret)

    local b = secret >> 5
    secret = prune(b)

    local c = secret << 11
    secret = prune(mix(c, secret))

    return secret
end

-- TODO:
