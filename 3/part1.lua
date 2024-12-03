local Part1 = {}

function Part1.find(input)
    local instructions = {}
    for instr_str in input:gmatch("mul%(%d%d?%d?,%d%d?%d?%)") do
        -- print(instr_str)
        local left, right = string.match(instr_str, "mul%((%d+),(%d+)%)")
        local instr = {
            left = tonumber(left),
            right = tonumber(right)
        }
        table.insert(instructions, instr)
    end
    return instructions
end

function Part1.run(instructions)
    local num = 0
    for _, instr in ipairs(instructions) do
        num = num + instr.left * instr.right
    end
    return num
end

return Part1
