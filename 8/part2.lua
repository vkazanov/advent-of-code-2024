local tins = table.insert
local tconc = table.concat
local trem = table.concat

-- local PRINT = true
local PRINT = false

local function find_nodes(map)
    local freq2coords = {}
    for r, _ in ipairs(map) do
        for c, _ in ipairs(map[r]) do
            local freq = map[r][c]
            if map[r][c] ~= "." then
                if PRINT then print("node: " .. r .. "/" .. c) end

                if not freq2coords[freq] then freq2coords[freq] = {} end
                tins(freq2coords[freq], { row = r, col = c })
            end
        end
    end

    return freq2coords
end

local function find_antinodes(nodes, max_r, max_c)
    local antinodes = {}
    for i in ipairs(nodes) do
        for j in ipairs(nodes) do
            if i == j then
                goto continue
            end

            local left, right = nodes[i], nodes[j]
            if PRINT then print("left: " .. left.row .. "," .. left.col) end
            if PRINT then print("right: " .. right.row .. "," .. right.col) end

            local r_diff = right.row - left.row
            local c_diff = right.col - left.col

            local anti_r = right.row
            local anti_c = right.col

            while anti_r <= max_r and anti_r >= 1 and anti_c <= max_c and anti_c >= 1 do
                if PRINT then print("anti: " .. anti_r .. "/" .. anti_c) end
                tins(antinodes, { row = anti_r, col = anti_c })
                anti_r = anti_r + r_diff; anti_c = anti_c + c_diff
            end

            ::continue::
        end
    end
    return antinodes
end

do
    local map = {
        {".", ".", ".", ".", "."},
        {".", ".", ".", ".", "."},
        {".", ".", ".", "a", "."},
        {".", ".", ".", ".", "."},
        {".", ".", ".", ".", "."},
    }

    local freq2coords = find_nodes(map)
    local freq_num = 0; for _, _ in pairs(freq2coords) do freq_num = freq_num + 1 end
    assert(freq_num == 1)
    assert(freq2coords["a"][1].row == 3)
    assert(freq2coords["a"][1].col == 4)
end

do
    local map = {
        {".", ".", ".", ".", "."},
        {".", "a", ".", ".", "."},
        {".", ".", ".", "a", "."},
        {".", ".", "b", ".", "."},
        {".", ".", ".", ".", "."},
    }

    local freq2coords = find_nodes(map)
    local freq_num = 0; for _, _ in pairs(freq2coords) do freq_num = freq_num + 1 end
    assert(freq_num == 2)

    assert(#freq2coords["a"] == 2)
    assert(freq2coords["a"][1].row == 2)
    assert(freq2coords["a"][1].col == 2)
    assert(freq2coords["a"][2].row == 3)
    assert(freq2coords["a"][2].col == 4)

    assert(#freq2coords["b"] == 1)
    assert(freq2coords["b"][1].row == 4)
    assert(freq2coords["b"][1].col == 3)
end

do
    if PRINT then print("NEXT") end

    local map = { { ".", ".", ".", "a", ".", ".", "a"} }
    local freq2coords = find_nodes(map)
    assert(freq2coords["a"])
    assert(#freq2coords["a"] == 2)

    local antinodes = find_antinodes(freq2coords["a"], #map, #map[1])
    assert(#antinodes == 3, #antinodes)
end

do
    if PRINT then print("NEXT") end

    local map = { {"a", ".", ".", "a", ".", ".", "."} }
    local freq2coords = find_nodes(map)
    assert(freq2coords["a"])
    assert(#freq2coords["a"] == 2)

    local antinodes = find_antinodes(freq2coords["a"], #map, #map[1])
    assert(#antinodes == 3)
end

do
    if PRINT then print("NEXT") end

    local map = {
        { "." },
        { "." },
        { "." },
        { "a" },
        { "." },
        { "." },
        { "a" },
        { "." },
        { "." },
        { "." },
    }
    local freq2coords = find_nodes(map)
    assert(freq2coords["a"])
    assert(#freq2coords["a"] == 2)

    local antinodes = find_antinodes(freq2coords["a"], #map, #map[1])
    assert(#antinodes == 4)
end

do
    if PRINT then print("NEXT") end

    local map = {
        { "T", ".", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", "T", ".", ".", ".", ".", ".", "." },
        { ".", "T", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", ".", ".", ".", ".", ".", ".", "." },
        { ".", ".", ".", ".", ".", ".", ".", ".", ".", "." },
    }
    local freq2coords = find_nodes(map)
    assert(freq2coords["T"])
    assert(#freq2coords["T"] == 3)

    local anti_set = {}
    local antinodes = find_antinodes(freq2coords["T"], #map, #map[1])
    for _, anti in pairs(antinodes) do
        local key = anti.row .. "|" .. anti.col
        anti_set[key] = true
    end

    local count = 0; for _, _ in pairs(anti_set) do count = count + 1 end
    assert(count == 9)
end

do
    local file = io.open("input.txt", "r")

    local map = {}
    local r = 1
    for line in file:lines() do
        local row = {}
        for c = 1, #line do
            local ch = string.sub(line, c, c)
            tins(row, ch)
        end
        table.insert(map, row)
        r = r + 1
    end
    file:close()

    assert(#map == 50)
    assert(#map[1] == 50)
    assert(map[1][1] == ".")
    assert(map[1][50] == ".")
    assert(map[50][1] == ".")
    assert(map[50][50] == ".")
    assert(map[50][49] == "V")

    local freq2coords = find_nodes(map)
    local anti_set = {}
    for _, nodes in pairs(freq2coords) do
        local antinodes = find_antinodes(nodes, #map, #map[1])
        for _, anti in pairs(antinodes) do
            local key = anti.row .. "|" .. anti.col
            anti_set[key] = true
        end
    end

    local count = 0; for _, _ in pairs(anti_set) do count = count + 1 end
    print(count)
end
