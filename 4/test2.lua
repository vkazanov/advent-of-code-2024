local P2 = require("part2")

do
    local input = {
        "M.S",
        ".A.",
        "M.S"
    }
    local width, str = P2.flatten(input)
    assert(width == 3)
    assert(str == "M.S" .. ".A." .. "M.S")
    local pattern = P2.flatten_pattern(P2.pattern1, 3)
    local count = P2.count(str, pattern, width)
    assert(count == 1)

end

do
    local input = {
        ".SM.SM",
        "A..A..",
        ".SM.SM"
    }
    local width, str = P2.flatten(input)
    assert(width == 6)
    local pattern = P2.flatten_pattern(P2.pattern1, width)
    local count = P2.count(str, pattern, width)
    print(count)
end

do
    local input = {
        "M.S",
        ".A.",
        "M.S",
        ".A.",
        "M.S",
    }
    local width, str = P2.flatten(input)
    assert(width == 3)
    local pattern = P2.flatten_pattern(P2.pattern1, 3)
    local count = P2.count(str, pattern, width)
    assert(count == 2)
end

-- do
--     local input = {
--         "MMSMMS",
--         "MAMMAM",
--         "MMSMMS",
--         "MAMMAM",
--         "MMSMMS",
--     }
--     local width, str = P2.flatten(input)
--     assert(width == 6)
--     local pattern = P2.flatten_pattern(P2.pattern1, width)
--     local count = P2.count(str, pattern, width)
--     assert(count == 4)
-- end

do
    local flat = P2.flatten_pattern(P2.pattern1, 3)
    assert(flat[1] == "M")
    assert(flat[3] == "S")
    assert(flat[5] == "A")
    assert(flat[7] == "M")
    assert(flat[9] == "S")
end

do
    local input = {
        "M.S",
        ".O.",
        "M.S"
    }
    local width, str = P2.flatten(input)
    local pattern = P2.flatten_pattern(P2.pattern1, width)
    local count = P2.count(str, pattern, width)
    assert(count == 0)
end



do
    local input = {
        "SSS",
        "SAA",
        "MMM",
        "MSX",
    }

    local width, line = P2.flatten(input)
    local pattern3 = P2.flatten_pattern(P2.pattern3, width)
    assert(P2.count(line, pattern3, width) == 1)
end

do
    local input = {
        "MMMSXXMASM",
        "MSAMXMSMSA",
        "AMXSXMAAMM",
        "MSAMASMSMX",
        "XMASAMXAMM",
        "XXAMMXXAMA",
        "SMSMSASXSS",
        "SAXAMASAAA",
        "MAMMMXMMMM",
        "MXMXAXMASX",
    }

    local width, line = P2.flatten(input)

    local pattern1 = P2.flatten_pattern(P2.pattern1, width)
    local pattern2 = P2.flatten_pattern(P2.pattern2, width)
    local pattern3 = P2.flatten_pattern(P2.pattern3, width)
    local pattern4 = P2.flatten_pattern(P2.pattern4, width)

    local count = P2.count(line, pattern1, width)
    count = count + P2.count(line, pattern2, width)
    count = count + P2.count(line, pattern3, width)
    count = count + P2.count(line, pattern4, width)
    print(count)
    assert(count == 9)
end

do
    local input = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        table.insert(input, line)
    end
    file:close()

    local width, line = P2.flatten(input)

    local pattern1 = P2.flatten_pattern(P2.pattern1, width)
    local pattern2 = P2.flatten_pattern(P2.pattern2, width)
    local pattern3 = P2.flatten_pattern(P2.pattern3, width)
    local pattern4 = P2.flatten_pattern(P2.pattern4, width)

    local count = P2.count(line, pattern1, width)
    count = count + P2.count(line, pattern2, width)
    count = count + P2.count(line, pattern3, width)
    count = count + P2.count(line, pattern4, width)
    print("Res: " .. count)
end
