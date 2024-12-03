P2 = require("part2")

do
    local instrs = P2.find("mul(44,46)")
    assert(#instrs == 1, "Wrong number of instrs")

    instrs = P2.find("mul(4444,46)")
    assert(#instrs == 0, "Wrong number of instrs")

    instrs = P2.find("mul(,46)")
    assert(#instrs == 0, "Wrong number of instrs")
end

do
    local instrs = P2.find("do(44,46)")
    assert(#instrs == 0, "Wrong number of instrs")

    local instrs = P2.find("do()")
    assert(#instrs == 1, "Wrong number of instrs")
end

do
    local instrs = P2.find("don't(44,46)")
    assert(#instrs == 0, "Wrong number of instrs")

    local instrs = P2.find("don't()")
    assert(#instrs == 1, "Wrong number of instrs")
end

do
    local instrs = P2.find("mul(44,46)lksjahyri3uhmulmul(1,2)")
    assert(#instrs == 2, "Wrong instr num")

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
    local file = io.open("input.txt", "r")
    if not file then
        print("Could not open file!")
        return
    end
    local line = file:read("*all")
    file:close()

    local instrs = P2.find(line)
    local res = P2.run(instrs)
    assert(res == 83158140, "Wrong result")
end
