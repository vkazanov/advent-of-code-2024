local aoc = {}

local tins = table.insert
local tcon = table.concat
local trem = table.remove
local tmov = table.move
local tunp = table.unpack

 -- Generic utils

aoc.PRINT = true
function aoc.mayprint(...)
    if aoc.PRINT then
        print(...)
    end
end

function aoc.sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

function aoc.fline(fname)
    fname = fname or "input.txt"
    local f <close> = io.open(fname, "r")
    return f:read("*all")
end

function aoc.flines(fname)
    fname = fname or "input.txt"
    local f = io.open(fname, "r")
    return f:lines()
end

function aoc.str_split(str, conv, pattern)
    if not conv then conv = tonumber; pattern = "%d+" end

    local elements = {}
    for e in str:gmatch(pattern) do tins(elements, conv(e)) end

    return elements
end

function aoc.arr_eq(arr1, arr2)
    if #arr1 ~= #arr2 then
        return false
    end

    for i = 1, #arr1 do
        if arr1[i] ~= arr2[i] then
            return false
        end
    end

    return true
end

function aoc.str_to_arr(str, conv_func)
    if not conv_func then
        conv_func = function(i) return i end
    end
    local chars = {}
    for i = 1, #str do
        local ch = str:sub(i, i)
        chars[i] = conv_func and conv_func(ch) or ch
    end
    return chars
end

function aoc.str_to_intarr(str)
    return aoc.str_to_arr(str, tonumber)
end

function aoc.foldl(f, acc, list)
    assert(f and acc and list)
    for _, v in ipairs(list) do acc = f(acc, v) end
  return acc
end

function aoc.gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end

function aoc.permutations(t)
    local results = {}

    -- Helper function: permute the table 'arr' using the first 'n' elements
    local function permute(arr, n)
        if n == 1 then
            -- Make a copy to avoid referencing the same table
            local copy = {}
            for i = 1, #arr do
                copy[i] = arr[i]
            end
            table.insert(results, copy)
        else
            for i = 1, n do
                -- Swap elements
                arr[i], arr[n] = arr[n], arr[i]
                -- Recurse for the next position
                permute(arr, n - 1)
                -- Swap back (backtrack)
                arr[i], arr[n] = arr[n], arr[i]
            end
        end
    end

    -- Start the recursive process
    permute(t, #t)

    return results
end

function aoc.bin2dec(bin_str)
    local result = 0
    for i = 1, #bin_str do
        result = (result << 1) + (bin_str:sub(i, i) == "1" and 1 or 0)
    end
    return result
end

 -- Sets

local Set = {}

function aoc.Set(init)
    local self = setmetatable({}, Set)
    Set.__index = Set
    if init then for _, v in pairs(init) do self[v] = true end end
    return self
end

function Set:__tostring()
    return "{" .. tcon(self:members(), ",") .. "}"
end

function Set:size()
    local s_size = 0
    for _, _ in pairs(self) do s_size = s_size + 1 end
    return s_size
end

function Set:is_member(e)
    return self[e] == true
end

function Set:is_empty()
    return self:size() == 0
end

function Set:members()
    local members = {}
    for k, _ in pairs(self) do
        if self[k] then tins(members, k) end
    end
    return members
end

function Set:intersect(r)
    assert(r)
    local intersection = aoc.Set()
    for l_k in pairs(self) do
        if r[l_k] then intersection[l_k] = true end
    end
    return intersection
end
function Set:inter(r) return self:intersect(r) end

function Set:difference(r)
    assert(r)
    local diff = aoc.Set()
    for l_k in pairs(self) do
        if not r[l_k] then diff[l_k] = true end
    end
    return diff
end
function Set:diff(r) return self:difference(r) end

function Set:union(r)
    assert(r)
    local union = aoc.Set()
    for s_k in pairs(self) do union[s_k] = true end
    for r_k in pairs(r) do union[r_k] = true end
    return union
end

function Set:add(e)
    assert(e)
    self[e] = true
end

function Set:remove(e)
    assert(e)
    self[e] = nil
end

 -- Vector class

-- let's make sure vectors with the same coords are the same objects. This makes it
-- possible to use them as object keys
--
local vecs = setmetatable({}, { __mode = "v" })

local Vec = {}

function aoc.Vec(x, y)
    if type(x) == "table" then assert(not y); local t = x; x, y = t[1], t[2]
    else assert(type(x) == type(y) and x and y) end

    local key = x .. "," .. y
    local found = vecs[key]
    if found then return found end

    local v = setmetatable({ x = x, y = y }, Vec)
    Vec.__index = Vec
    vecs[key] = v
    return v
end

function Vec.__add(left, right) return aoc.Vec(left.x + right.x, left.y + right.y) end
function Vec.__sub(left, right) return aoc.Vec(left.x - right.x, left.y - right.y) end
function Vec.__eq(left, right) return (left.y == right.y) and (left.x == right.x) end
function Vec.__tostring(p) return p.x .. "," .. p.y end

function Vec:wrap(dim) return aoc.Vec{self.x % dim.x, self.y % dim.y} end
function Vec:times(times) return aoc.Vec(self.x * times, self.y * times) end

aoc.LEFT = aoc.Vec{-1, 0}
aoc.RIGHT = aoc.Vec{1, 0}
aoc.UP = aoc.Vec{0, -1}
aoc.DOWN = aoc.Vec{0, 1}

aoc.dir_to_rot_clock = {
    [aoc.LEFT] = aoc.UP,
    [aoc.RIGHT] = aoc.DOWN,
    [aoc.UP] = aoc.RIGHT,
    [aoc.DOWN] = aoc.LEFT,
}

aoc.dir_to_rot_counter = {
    [aoc.LEFT] = aoc.DOWN,
    [aoc.RIGHT] = aoc.UP,
    [aoc.UP] = aoc.LEFT,
    [aoc.DOWN] = aoc.RIGHT,
}

aoc.dir_to_rev = {
    [aoc.LEFT] = aoc.RIGHT,
    [aoc.RIGHT] = aoc.LEFT,
    [aoc.UP] = aoc.DOWN,
    [aoc.DOWN] = aoc.UP,
}

function Vec:rot_clock() return aoc.dir_to_rot_clock[self] end
function Vec:rot_counter() return aoc.dir_to_rot_counter[self] end
function Vec:reverse() return aoc.dir_to_rev[self] end
function Vec:manhattan_len() return math.abs(self.x) + math.abs(self.y) end

function Vec:up() return self + aoc.UP end
function Vec:up_left() return aoc.Vec(self.x - 1, self.y - 1) end
function Vec:up_right() return aoc.Vec(self.x + 1, self.y - 1) end
function Vec:right() return self + aoc.RIGHT end
function Vec:down() return self + aoc.DOWN end
function Vec:down_left() return aoc.Vec(self.x - 1, self.y + 1) end
function Vec:down_right() return aoc.Vec(self.x + 1, self.y + 1) end
function Vec:left() return self + aoc.LEFT end

 -- Trie class

local Trie = {}
Trie.__index = Trie

function aoc.Trie()
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

 -- Map

local Map = {}
function Map:in_bounds(pos)
    if pos.x < 0 or pos.x >= self.dim.width then return false end
    if pos.y < 0 or pos.y >= self.dim.height then return false end
    return true
end

function Map:print(conv_func)
    -- if not aoc.PRINT then return end

    conv_func = conv_func or function(ch, _, _) return ch end

    for y = 0, self.dim.height - 1 do
        for x = 0, self.dim.width - 1 do
            local ch = self[aoc.Vec{x, y}]
            ch = conv_func(ch, x, y)
            io.write(ch)
        end
        io.write("\n")
    end
end

function Map:apply(func)
    assert(func)

    for y = 0, self.dim.height - 1 do
        for x = 0, self.dim.width - 1 do
            func(aoc.Vec{x, y}, self[aoc.Vec{x, y}])
        end
    end
end

function aoc.empty_map(max_pos)
    local map = setmetatable({}, Map)
    Map.__index = Map

    for x = 0, max_pos.x do
        for y = 0, max_pos.y do
            map[aoc.Vec{x, y}] = "."
        end
    end

    map.dim = { width = max_pos.x + 1, height = max_pos.y + 1}
    return map
end

function aoc.mappify_lines(lines, conv_func)
    local map = setmetatable({}, Map)
    Map.__index = Map

    conv_func = conv_func or function(ch, _) return ch end

    local w, h = 0, 0

    local y = 0
    for line in lines do
        local x = 0
        for ch in line:gmatch(".") do
            map[aoc.Vec{x, y}] = conv_func(ch, aoc.Vec{x, y})
            x = x + 1
            w = math.max(w, x)
        end
        y = y + 1
        h = math.max(h, y)
    end
    map.dim = { width = w, height = h }

    return map
end

function aoc.mappify_double(lines, conv_func)
    local map = setmetatable({}, Map)
    Map.__index = Map
    assert(conv_func)

    local w, h = 0, 0

    local y = 0
    for line in lines do
        local x = 0
        for ch in line:gmatch(".") do
            map[aoc.Vec{x, y}], map[aoc.Vec{x + 1, y}] = conv_func(ch, x, y)
            x = x + 2
            w = math.max(w, x)
        end
        y = y + 1
        h = math.max(h, y)
    end
    map.dim = { width = w, height = h }

    return map
end

 -- end of the module

return aoc
