local aoc = require "aoc"
local Deque = require "deque"

local unpack = table.unpack
local tins = table.insert

local input = [[
x00 AND y00 -> z05
x01 AND y01 -> z02
x02 AND y02 -> z01
x03 AND y03 -> z03
x04 AND y04 -> z04
x05 AND y05 -> z00
]]

local OPS = {
    AND = function(l, r) return l and r end,
    OR = function(l, r) return l or r end,
    XOR = function(l, r) return l ~= r end,
}

local gates = {}
local wire2init = {}
for line in input:gmatch("[^\n]+") do
-- for line in aoc.flines() do
    local wire, value = line:match("([^:]+): (%d)")
    if wire then
        print("wire " .. line)
        wire2init[wire] = value == "1"
        goto continue
    end
    local left, op, right, target = line:match("([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+->%s+([^%s]+)")
    if left then
        print("gate " .. line)
        assert(OPS[op])
        tins(gates, { left, right, OPS[op], target })
    end

    ::continue::
end

local function target_swap(target, swaps)
    return swaps[target] or target
end

local function run(wire2init, gates_init, swaps)
    local wire2value = {}
    for wire, value in pairs(wire2init) do wire2value[wire] = value end

    local queue = Deque.new()
    for _, gate in pairs(gates_init) do queue:push_right(gate) end

    while not queue:is_empty() do
        local gate = queue:pop_right()
        local left, right, op, target = unpack(gate)
        if wire2value[left] == nil or wire2value[right] == nil then
            queue:push_left(gate)
            goto continue
        end

        wire2value[target_swap(target, swaps)] = op(wire2value[left], wire2value[right])
        -- wire2value[target] = op(wire2value[left], wire2value[right])
        ::continue::
    end

    local result = 0
    for wire, value in pairs(wire2value) do
        if wire:sub(1, 1) == "z" and value then
            local bit = tonumber(wire:match("z(%d+)"))
            result = result | (1 << bit)
        end
    end

    return result
end

local function bin2wires(wire_name, bin_str)
    local result = {}
    for i = 0, 44 do
        local wire = string.format("%s%02d", wire_name, i)
        local str_i = #bin_str - i
        local value
        if str_i <= 0 then
            value = false
        else
            value = bin_str:sub(str_i, str_i) == "1"
        end
        result[wire] = value
    end
    return result
end

local x_wires = bin2wires("x", "101010")
local y_wires = bin2wires("y", "101100")
local expect = aoc.bin2dec(    "101000")

wire2init = {}
for k, v in pairs(x_wires) do wire2init[k] = v end
for k, v in pairs(y_wires) do wire2init[k] = v end

local swaps = {
    ["z05"] = "z00",
    ["z00"] = "z05",

    ["z02"] = "z01",
    ["z01"] = "z02",
}
local res = run(wire2init, gates, swaps)
assert(res == expect, res)
