P2 = require("part1")

do
    local instrs = P2.find("mul(44,46)")
    assert(#instrs == 1, "Wrong number of instrs")

    instrs = P2.find("mul(4444,46)")
    assert(#instrs == 0, "Wrong number of instrs")

    instrs = P2.find("mul(,46)")
    assert(#instrs == 0, "Wrong number of instrs")
end

do
    local instrs = P2.find("mul(44,46)lksjahyri3uhmulmul(1,2)")
    assert(#instrs == 2, "Wrong instr num")

    assert(instrs[1].left == 44)
    assert(instrs[1].right == 46)

    assert(instrs[2].left == 1)
    assert(instrs[2].right == 2)

    local res = P2.run(instrs)
    assert(res == 44 * 46 + 1 * 2)
end

do
    local instrs = P2.find([[mul(892,588)
mul(4,214)]])
    assert(#instrs == 2)
    assert(P2.run(instrs)== 892*588 + 4*214)
end


do
    local instrs = P2.find("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
    assert(P2.run(instrs)== 161)
end

-- Part 1
do
    local file = io.open("input.txt", "r")
    if not file then
        print("Could not open file!")
        return
    end
    local line = file:read("*all")
    file:close()

    local instrs = P2.find(line)
    assert(#instrs == 746, "Wrong instr num")
    local res = P2.run(instrs)
    assert(res == 173785482, "Wrong result")
end
