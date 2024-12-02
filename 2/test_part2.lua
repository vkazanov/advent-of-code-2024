P2 = require("part2")

do
    local report = P2.parse_report("1 2 3")
    assert(#report == 3)
    assert(report[1] == 1)
    assert(report[2] == 2)
    assert(report[3] == 3)
end

do
    assert(P2.is_safe({7, 5, 3}))
    assert(P2.is_safe({3, 5, 7}))
    assert(not P2.is_safe({1, 5, 7}))
    assert(not P2.is_safe({7, 2, 1}))
end
