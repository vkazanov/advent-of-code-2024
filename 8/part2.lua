local tins = table.insert


local function find_nodes(map)
    local freq2coords = {}
    for r, _ in ipairs(map) do
        for c, _ in ipairs(map[r]) do
            local freq = map[r][c]
            if map[r][c] ~= "." then
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

            local r_diff = right.row - left.row
            local c_diff = right.col - left.col

            local anti_r = right.row
            local anti_c = right.col

            while anti_r <= max_r and anti_r >= 1 and anti_c <= max_c and anti_c >= 1 do
                tins(antinodes, { row = anti_r, col = anti_c })
                anti_r = anti_r + r_diff; anti_c = anti_c + c_diff
            end

            ::continue::
        end
    end
    return antinodes
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
    assert(count == 1190, count)
end
