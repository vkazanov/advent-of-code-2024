local P1 = require("part1")

do
    local str = "test"
    assert(P1.reverse_str(str) == "tset")
end

do
    local test = {
        "11111",
        "22222",
        "33333",
        "44444",
        "55555",
    }
    local lines = P1.find_lines(test)
    assert(lines[1] == "11111")
    assert(lines[11] == "12345")
    assert(lines[12] == "54321")
    assert(lines[21] == "12345")
    assert(lines[22] == "54321")
    assert(lines[31] == "2345")
    assert(lines[32] == "5432")
    assert(lines[33] == "345")
    assert(lines[34] == "543")
    assert(lines[35] == "45")
    assert(lines[36] == "54")
    assert(lines[37] == "5")
    assert(lines[38] == "5")
    assert(lines[39] == "54321")
    assert(lines[40] == "12345")

    assert(#lines == 2 * (#test + #test[1] + #test + #test[1] - 1 + #test[1] - 1 + #test))
end

do
    local test = {
        "ab",
        "de",
    }
    local lines = P1.find_lines(test)
    assert(#lines == 2 * (2 + 2 + 3 + 3))
end

do
    local test = {
        "..X...",
        ".SAMX.",
        ".A..A.",
        "XMAS.S",
        ".X...."
    }
    local lines = P1.find_lines(test)
    local total_count = 0
    for _, line in pairs(lines) do
        total_count = total_count + P1.count_occurs(line, "XMAS")
    end
    assert(total_count == 4)
end


do
    assert(P1.count_occurs("MMMSXXMASM", "XMAS") == 1)

    assert(P1.count_occurs("MSAMXMSMSA", "XMAS") == 0)
    assert(P1.count_occurs(P1.reverse_str("MSAMXMSMSA"), "XMAS") == 1)
end


do
    local test = {
        "MMMSXXMASM",
        "MSAMXMSMSA",
        "AMXSXMAAMM",
        "MSAMASMSMX",
        "XMASAMXAMM",
        "XXAMMXXAMA",
        "SMSMSASXSS",
        "SAXAMASAAA",
        "MAMMMXMMMM",
        "MXMXAXMASX"
    }
    local lines = P1.find_lines(test)
    local total_count = 0
    for _, line in pairs(lines) do
        total_count = total_count + P1.count_occurs(line, "XMAS")
    end
    assert(total_count == 18)
end

do
    local input = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        table.insert(input, line)
    end

    local lines = P1.find_lines(input)
    local total_count = 0
    for _, line in pairs(lines) do
        total_count = total_count + P1.count_occurs(line, "XMAS")
    end
    assert(total_count == 2685)
    file:close()
end
