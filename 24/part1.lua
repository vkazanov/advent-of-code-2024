local aoc = require "aoc"
local Deque = require "deque"

local unpack = table.unpack

local OPS = {
    AND = function(l, r) return l and r end,
    OR = function(l, r) return l or r end,
    XOR = function(l, r) return l ~= r end,
}

local wire2value = {}
local queue = Deque.new()
for line in aoc.flines() do
    local wire, value = line:match("([^:]+): (%d)")
    if wire then
        wire2value[wire] = value == "1"
        goto continue
    end
    local left, op, right, target = line:match("([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+->%s+([^%s]+)")
    if left then
        assert(OPS[op])
        queue:push_right{ left, right, OPS[op], target }
    end

    ::continue::
end

while not queue:is_empty() do
    local gate = queue:pop_right()
    local left, right, op, target = unpack(gate)
    if wire2value[left] == nil or wire2value[right] == nil then
        queue:push_left(gate)
        goto continue
    end

    assert(wire2value[target] == nil)
    wire2value[target] = op(wire2value[left], wire2value[right])
    ::continue::
end

local result = 0
for wire, value in pairs(wire2value) do
    if wire:sub(1, 1) == "z" and value then
        local bit = tonumber(wire:match("z(%d+)"))
        result = result | (1 << bit)
    end
end

assert(result == 59619940979346, result)
