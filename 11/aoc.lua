local aoc = {}

aoc.tins = table.insert
aoc.tcon = table.concat
aoc.trem = table.remove

aoc.PRINT = true
function aoc.mayprint(...)
    if aoc.PRINT then
        print(...)
    end
end

function aoc.fline(fname)
    local f <close> = io.open(fname, "r")
    return f:read("*all")
end

function aoc.flines(fname)
    local f = io.open(fname, "r")
    return f:lines()
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
function Pos.up(p) return aoc.pos(p.r - 1, p.c) end
function Pos.right(p) return aoc.pos(p.r, p.c + 1) end
function Pos.down(p) return aoc.pos(p.r + 1, p.c) end
function Pos.left(p) return aoc.pos(p.r,  p.c - 1) end

function aoc.mappify(lines)
    local map = {}

    local w = 1
    local r = 0

    for line in lines do
        r = r + 1
        local c = 0
        for ch in line:gmatch(".") do
            c = c + 1
            map[aoc.pos(r, c)] = tonumber(ch) or -1
        end
        w = math.max(w, c)
    end
    map.dim = { width = w, height = r }

    -- TODO: move to the prototype?
    map.print = function(conv_func)
        if not aoc.PRINT then return end

        if not conv_func then
            conv_func = function(ch) return ch >= 0 and ch or "." end
        end

        for r2 = 1, r do
            for c2 = 1, w do
                local ch = map[aoc.pos(r2, c2)]
                ch = conv_func(ch)
                io.write(ch >= 0 and ch or ".")
            end
            io.write("\n")
        end
    end

    return map
end

return aoc
