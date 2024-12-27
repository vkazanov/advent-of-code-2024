local aoc = {}

aoc.tins = table.insert
aoc.tcon = table.concat
aoc.trem = table.remove

aoc.PRINT = false
function aoc.mayprint(...)
    if aoc.PRINT then
        print(...)
    end
end

function aoc.fline(fname)
    if not fname then fname = "input.txt" end
    local f = io.open(fname, "r")
    return f:read("*all")
end

function aoc.flines(fname)
    if not fname then fname = "input.txt" end
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

return aoc
