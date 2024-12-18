local aoc = {}

aoc.tins = table.insert
aoc.tcon = table.concat
aoc.trem = table.remove
aoc.tmov = table.move
aoc.tunp = table.unpack

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
    for e in str:gmatch(pattern) do aoc.tins(elements, conv(e)) end

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

local vecs = setmetatable({}, { __mode = "v" })
local Vec = {}

function aoc.vec(x, y)
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

function Vec.__add(left, right) return aoc.vec(left.x + right.x, left.y + right.y) end
function Vec.__sub(left, right) return aoc.vec(left.x - right.x, left.y - right.y) end
function Vec.__eq(left, right) return (left.y == right.y) and (left.x == right.x) end
function Vec.__tostring(p) return p.x .. "," .. p.y end

function Vec:wrap(dim) return aoc.vec{self.x % dim.x, self.y % dim.y} end
function Vec:times(times) return aoc.vec(self.x * times, self.y * times) end

aoc.LEFT = aoc.vec{-1, 0}
aoc.RIGHT = aoc.vec{1, 0}
aoc.UP = aoc.vec{0, -1}
aoc.DOWN = aoc.vec{0, 1}

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

function Vec:up() return self + aoc.UP end
function Vec:up_left() return aoc.vec(self.x - 1, self.y - 1) end
function Vec:up_right() return aoc.vec(self.x + 1, self.y - 1) end
function Vec:right() return self + aoc.RIGHT end
function Vec:down() return self + aoc.DOWN end
function Vec:down_left() return aoc.vec(self.x - 1, self.y + 1) end
function Vec:down_right() return aoc.vec(self.x + 1, self.y + 1) end
function Vec:left() return self + aoc.LEFT end

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
            local ch = self[aoc.vec{x, y}]
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
            func(aoc.vec{x, y}, self[aoc.vec{x, y}])
        end
    end
end

function aoc.empty_map(max_pos)
    local map = setmetatable({}, Map)
    Map.__index = Map

    for x = 0, max_pos.x do
        for y = 0, max_pos.y do
            map[aoc.vec{x, y}] = "."
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
            map[aoc.vec{x, y}] = conv_func(ch, aoc.vec{x, y})
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
            map[aoc.vec{x, y}], map[aoc.vec{x + 1, y}] = conv_func(ch, x, y)
            x = x + 2
            w = math.max(w, x)
        end
        y = y + 1
        h = math.max(h, y)
    end
    map.dim = { width = w, height = h }

    return map
end

return aoc
