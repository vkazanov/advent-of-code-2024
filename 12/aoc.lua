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

local poss = setmetatable({}, { __mode = "v" })
local Pos = {}

function aoc.pos(r, c)
    if type(r) == "table" then
        c = r[2]
        r = r[1]
    else
        assert(type(r) == type(c))
    end

    local key = r .. "," .. c
    local found = poss[key]
    if found then return found end
    local p = setmetatable({ r = r, c = c }, Pos)
    poss[key] = p
    Pos.__index = Pos
    return p
end

function Pos.__add(l, r) return aoc.pos(l.r + r.r, l.r + r.c) end
function Pos.__tostring(p) return p.r .. "," .. p.c end

function Pos:up() return aoc.pos(self.r - 1, self.c) end
function Pos:up_left() return aoc.pos(self.r - 1, self.c - 1) end
function Pos:up_right() return aoc.pos(self.r - 1, self.c + 1) end
function Pos:right() return aoc.pos(self.r, self.c + 1) end
function Pos:down() return aoc.pos(self.r + 1, self.c) end
function Pos:down_left() return aoc.pos(self.r + 1, self.c - 1) end
function Pos:down_right() return aoc.pos(self.r + 1, self.c + 1) end
function Pos:left() return aoc.pos(self.r,  self.c - 1) end

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
