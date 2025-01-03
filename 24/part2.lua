local aoc = require "aoc"
local Deque = require "deque"

local unpack = table.unpack
local tins = table.insert

local OPS = {
    AND = function(l, r) return l and r end,
    OR = function(l, r) return l or r end,
    XOR = function(l, r) return l ~= r end,
}

local gates = {}
for line in aoc.flines() do
    local wire = line:match("([^:]+): (%d)")
    if wire then goto continue end

    local left, op, right, target = line:match("([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+->%s+([^%s]+)")
    if left then
        assert(OPS[op])
        tins(gates, { left, right, OPS[op], target })
    end

    ::continue::
end

local function target_swap(target, swaps)
    return swaps[target] or target
end

local function run(wire2value_init, gates_init, swaps)
    local wire2value = {}
    for wire, value in pairs(wire2value_init) do wire2value[wire] = value end

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

local x_wires = bin2wires("x", "11111111111111111111111111111111111111111111")
local y_wires = bin2wires("y", "00000000000000000000000000000000000000000000")
local expect = aoc.bin2dec(    "11111111111111111111111111111111111111111111")

local wire2init = {}
for k, v in pairs(x_wires) do wire2init[k] = v end
for k, v in pairs(y_wires) do wire2init[k] = v end

local swaps = {
    ["bpt"] = "krj",
    ["krj"] = "bpt",

    ["z31"] = "mfm",
    ["mfm"] = "z31",

    ["z06"] = "fkp",
    ["fkp"] = "z06",

    ["z11"] = "ngr",
    ["ngr"] = "z11",
}

local res = run(wire2init, gates, swaps)
assert(res == expect, res)

local swaps_output = { "bpt", "krj", "z31", "mfm", "z06", "fkp", "z11", "ngr" }
table.sort(swaps_output)
print(table.concat(swaps_output, ","))
