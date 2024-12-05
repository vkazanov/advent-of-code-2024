
local function check(rules, update)
    print(table.concat(update, ","))
    local page_set = {}
    for _, p in pairs(update) do
        page_set[p] = true
    end

    local rules_map = {}
    for _, rule_str in pairs(rules) do
        local left, right = rule_str:match("(%d+)|(%d+)")
        left = tonumber(left)
        right = tonumber(right)
        if page_set[left] and page_set[right] then
            rules_map[left] = right
        end
    end
    for k, v in pairs(rules_map) do
        print(k .. " before " .. v)
    end

    for i, this in pairs(update) do
        for j, that in pairs(update) do
            if i == j then
                goto continue
            end

            if i < j then
                if rules_map[that] == this then
                    return false
                end
            elseif i > j then
                if rules_map[this] == that then
                    return false
                end
            end

            ::continue::
        end
    end

    return true, update[#update // 2 + 1]
end


do
    local rules = {
        "47|53",
        "97|13",
        "97|61",
        "97|47",
        "75|29",
        "61|13",
        "75|53",
        "29|13",
        "97|29",
        "53|29",
        "61|53",
        "97|53",
        "61|29",
        "47|13",
        "75|47",
        "97|75",
        "47|61",
        "75|61",
        "47|29",
        "75|13",
        "53|13,"
    }

    local correct, mid
    correct, mid = check(rules, { 75, 47, 61, 53, 29 })
    assert(correct)
    assert(mid == 61)

    correct, mid = check(rules, { 97,61,53,29,13 })
    assert(correct)
    assert(mid == 53)

    correct, mid = check(rules, { 75,29,13 })
    assert(correct)
    assert(mid == 29)

    assert(not check(rules, { 75,97,47,61,53 }))
    assert(not check(rules, { 61,13,29 }))
    assert(not check(rules, { 97, 13, 75, 29, 47 }))
end

do
    local rules = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        if line == "" then break end

        table.insert(rules, line)
    end

    local count = 0
    for line in file:lines() do
        local update = {}
        for page in line:gmatch("%d+") do
            table.insert(update, tonumber(page))
        end
        local correct, mid = check(rules, update)
        if correct then
            count = count + mid
        end
    end
    assert(count == 5248)

    file:close()
end
