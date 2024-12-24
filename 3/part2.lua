local tins = table.insert

local function parse(input)
    local instrs = {}
    for instr_str in input:gmatch("[%a']+%([%d,]*%)") do
        local left, right = string.match(instr_str, "mul%((%d%d?%d?),(%d%d?%d?)%)")
        if left ~= nil then
            tins(instrs, {
                type = "MUL",
                left = tonumber(left),
                right = tonumber(right)
            })
        elseif string.match(instr_str, "do%(%)") then
            tins(instrs, { type = "DO", })
        elseif string.match(instr_str, "don't%(%)") then
            tins(instrs, { type = "DONT", })
        end
    end
    return instrs
end

local function run(instructions)
    local num = 0
    local is_enabled = true
    for _, instr in ipairs(instructions) do
        if is_enabled and instr.type == "MUL" then
            num = num + instr.left * instr.right
        elseif instr.type == "DO" then
            is_enabled = true
        elseif instr.type == "DONT" then
            is_enabled = false
        end
    end
    return num
end

local file = io.open("input.txt", "r")
local line = file:read("*all")

local instrs = parse(line)
local res = run(instrs)
assert(res == 83158140, "Wrong result")
