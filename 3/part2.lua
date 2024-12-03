local Part2 = {}

local INSTR_PATTERN <const> = "[%a']+%([%d,]*%)"

local MUL_PATTERN <const> = "mul%((%d%d?%d?),(%d%d?%d?)%)"
local DO_PATTERN <const> = "do%(%)"
local DONT_PATTERN <const> = "don't%(%)"

function Part2.find(input)
    local instructions = {}
    for instr_str in input:gmatch(INSTR_PATTERN) do

        local left, right = string.match(instr_str, MUL_PATTERN)
        if left ~= nil then
            local instr = {
                type = "MUL",
                left = tonumber(left),
                right = tonumber(right)
            }
            table.insert(instructions, instr)
            goto next_instr
        end

        local m = string.match(instr_str, DO_PATTERN)
        if m ~= nil then
            local instr = {
                type = "DO",
            }
            table.insert(instructions, instr)
            goto next_instr
        end

        local m = string.match(instr_str, DONT_PATTERN)
        if m ~= nil then
            local instr = {
                type = "DONT",
            }
            table.insert(instructions, instr)
            goto next_instr
        end

        ::next_instr::
    end
    return instructions
end

function Part2.run(instructions)
    local num = 0
    local is_enabled = true
    for _, instr in ipairs(instructions) do
        if instr.type == "MUL" and is_enabled then
            num = num + instr.left * instr.right
        elseif instr.type == "DO" then
            is_enabled = true
        elseif instr.type == "DONT" then
            is_enabled = false
        end
    end
    return num
end

return Part2
