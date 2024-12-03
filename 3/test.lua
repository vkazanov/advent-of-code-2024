P1 = require("part1")

do
    local instrs = P1.find("mul(44,46)")
    assert(#instrs == 1, "Wrong number of instrs")

    instrs = P1.find("mul(4444,46)")
    assert(#instrs == 0, "Wrong number of instrs")

    instrs = P1.find("mul(,46)")
    assert(#instrs == 0, "Wrong number of instrs")
end

do
    local instrs = P1.find("mul(44,46)lksjahyri3uhmulmul(1,2)")
    assert(#instrs == 2, "Wrong instr num")

    assert(instrs[1].left == 44)
    assert(instrs[1].right == 46)

    assert(instrs[2].left == 1)
    assert(instrs[2].right == 2)

    local res = P1.run(instrs)
    assert(res == 44 * 46 + 1 * 2)
end

do
    local instrs = P1.find([[mul(892,588)
mul(4,214)]])
    assert(#instrs == 2)
    assert(P1.run(instrs)== 892*588 + 4*214)
end


do
    local instrs = P1.find("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
    assert(P1.run(instrs)== 161)
end

do
    local file = io.open("input.txt", "r")
    if not file then
        print("Could not open file!")
        return
    end
    local line = file:read("*all")
    file:close()

    local instrs = P1.find(line)
    print(#instrs)
    print(P1.run(instrs))
end
