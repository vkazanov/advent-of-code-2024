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
    return io.open(fname, "r"):read("*all")
end

function aoc.flines(fname)
    local lines = {}
    for l in io.open(fname, "r"):lines() do table.insert(lines, l) end
    return lines
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


return aoc
