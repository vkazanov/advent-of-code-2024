local function parse(input)
    local instructions = {}
    for instr_str in input:gmatch("mul%(%d%d?%d?,%d%d?%d?%)") do
        local left, right = string.match(instr_str, "mul%((%d+),(%d+)%)")
        local instr = {
            left = tonumber(left),
            right = tonumber(right)
        }
        table.insert(instructions, instr)
    end
    return instructions
end

local function run(instrs)
    local num = 0
    for _, instr in ipairs(instrs) do
        num = num + instr.left * instr.right
    end
    return num
end

local file = io.open("input.txt", "r")
local instrs = parse(file:read("*all"))
assert(#instrs == 746, "Wrong instr num")
assert(run(instrs) == 173785482, "Wrong result")
