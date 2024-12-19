local aoc = require "aoc"
aoc.PRINT = false
local mayprint = aoc.mayprint

local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local tunp = aoc.tunp
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function count(s, tr, cache)
    assert(cache)

    local res = cache[s]
    if res then return cache[s] end

    if #s == 0 then return 1 end

    res = 0
    for m in tr:prefix_lengths_of(s) do
        if m > 0 then
            res = res + count(s:sub(1 + m), tr, cache)
        end
    end

    cache[s] = res

    return res
end

local Trie = {

}
Trie.__index = Trie
function Trie.new()
    return setmetatable({
            branches={},
            is_leaf=false
    }, Trie)
end

function Trie:insert(str)
    if str == "" then
        self.is_leaf = true; return
    end


    local ch = str:sub(1, 1)
    local next_t = self.branches[ch]
    if not next_t then
        next_t = Trie.new()
        self.branches[ch] = next_t
    end

    next_t:insert(str:sub(2))
end

function Trie:prefix_lengths_of(str)
    local t, i = self, 1

    local function prefix_len_iter()
        while true do
            if not t then return nil end
            local has_found_leaf = t.is_leaf
            t = t.branches[str:sub(i, i)]
            i = i + 1
            if has_found_leaf then return i - 2 end
        end
    end

    return prefix_len_iter

end

local input = aoc.flines()
local pat_line = input()

local tr = Trie.new()
for p in pat_line:gmatch("([a-z]+)") do
    tr:insert(p)
end

input()

local res = 0
local cache = {}
for l in input do
    res = res + count(l, tr, cache)
end
assert(res == 603191454138773)
