local aoc = {}

aoc.tins = table.insert
aoc.tcon = table.concat
aoc.trem = table.remove
aoc.tmov = table.move

aoc.PRINT = true
function aoc.mayprint(...)
    if aoc.PRINT then
        print(...)
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

function Vec:up() return aoc.vec(self.x, self.y - 1) end
function Vec:up_left() return aoc.vec(self.x - 1, self.y - 1) end
function Vec:up_right() return aoc.vec(self.x + 1, self.y - 1) end
function Vec:right() return aoc.vec(self.x + 1, self.y) end
function Vec:down() return aoc.vec(self.x, self.y + 1) end
function Vec:down_left() return aoc.vec(self.x - 1, self.y + 1) end
function Vec:down_right() return aoc.vec(self.x + 1, self.y + 1) end
function Vec:left() return aoc.vec(self.x - 1, self.y) end

local Map = {}

function Map:print(conv_func)
    if not aoc.PRINT then return end

    conv_func = conv_func or function(ch) return ch end

    for r2 = 1, self.dim.height do
        for c2 = 1, self.dim.width do
            local ch = self[aoc.pos(r2, c2)]
            ch = conv_func(ch)
            io.write(ch)
        end
        io.write("\n")
    end
end

function aoc.mappify(lines, conv_func)
    local map = setmetatable({}, Map)
    Map.__index = Map

    conv_func = conv_func or function(ch) return ch end

    local w = 1
    local r = 0

    for line in lines do
        r = r + 1
        local c = 0
        for ch in line:gmatch(".") do
            c = c + 1
            map[aoc.pos(r, c)] = conv_func(ch)
        end
        w = math.max(w, c)
    end
    map.dim = { width = w, height = r }

    return map
end

return aoc
