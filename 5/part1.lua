
local function check(rules, update)
    -- print(table.concat(update, ","))
    local rules_map = {}
    for _, rule_str in pairs(rules) do
        rules_map[rule_str] = true
    end

    for i, this in pairs(update) do
        for j, that in pairs(update) do
            if i < j then
                if rules_map[that .. "|" .. this] then
                    return false
                end
            elseif i > j then
                if rules_map[this .. "|" .. that] then
                    return false
                end
            end
        end
    end

    return true, update[#update // 2 + 1]
end

local function fix(rules, update)
    local rules_map = {}
    for _, rule_str in pairs(rules) do
        rules_map[rule_str] = true
    end

    local fixed_update = {}
    for _, v in pairs(update) do table.insert(fixed_update, v) end

    for i, this in pairs(fixed_update) do
        for j, that in pairs(fixed_update) do
            if i < j then
                if rules_map[that .. "|" .. this] then
                    fixed_update[i] = that
                    fixed_update[j] = this
                    goto fixed
                end
            elseif i > j then
                if rules_map[this .. "|" .. that] then
                    fixed_update[j] = that
                    fixed_update[i] = this
                    goto fixed
                end
            end
        end
    end
    ::fixed::
    return fixed_update
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

    local is_correct, mid
    is_correct, mid = check(rules, { 75, 47, 61, 53, 29 })
    assert(is_correct)
    assert(mid == 61)

    is_correct, mid = check(rules, { 97,61,53,29,13 })
    assert(is_correct)
    assert(mid == 53)

    is_correct, mid = check(rules, { 75,29,13 })
    assert(is_correct)
    assert(mid == 29)

    -- incorrect ones

    local update = { 75, 97, 47, 61, 53 }
    print(table.concat(update, ","))
    is_correct = check(rules, update)
    assert(not is_correct)

    local fixed_update = fix(rules, update)
    print(table.concat(fixed_update, ","))
    is_correct, mid = check(rules, fixed_update)
    assert(is_correct)
    assert(mid == 47)

    update = { 61, 13, 29 }
    print(table.concat(update, ","))
    is_correct = check(rules, update)
    assert(not is_correct)

    fixed_update = fix(rules, update)
    print(table.concat(fixed_update, ","))
    is_correct, mid = check(rules, fixed_update)
    assert(is_correct)
    assert(mid == 29)

    update = { 97, 13, 75, 29, 47 }
    print(table.concat(update, ","))
    is_correct = check(rules, update)
    assert(not is_correct)

    fixed_update = update
    repeat
        fixed_update = fix(rules, fixed_update)
        print(table.concat(fixed_update, ","))
        is_correct, mid = check(rules, fixed_update)
    until is_correct
    assert(is_correct)
    assert(mid == 47)
end

do
    local rules = {}
    local file = io.open("input.txt", "r")
    for line in file:lines() do
        if line == "" then break end

        table.insert(rules, line)
    end
    assert(#rules == 1176)

    local num_correct, count_correct = 0, 0
    local num_fixed, count_fixed = 0, 0
    for line in file:lines() do
        local update = {}
        for page in line:gmatch("%d+") do
            table.insert(update, tonumber(page))
        end
        assert(#update % 2 == 1)

        print("\nupdat: " .. table.concat(update, ","))
        local is_correct, mid = check(rules, update)
        if is_correct then
            num_correct = num_correct + 1
            count_correct = count_correct + mid
            print("ok")

        else
            local fixed_update = update
            repeat
                fixed_update = fix(rules, fixed_update)
                print("fixed: " .. table.concat(fixed_update, ","))
                is_correct, mid = check(rules, fixed_update)
            until is_correct
            print("mid: " .. mid)
            debug.debug()
            num_fixed = num_fixed + 1
            count_fixed = count_fixed + mid
            print("fixed")
        end

    end

    assert(count_correct == 5248)
    assert(count_correct == 4507)

    file:close()
end
