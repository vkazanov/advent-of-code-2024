local aoc = require "aoc"
aoc.PRINT = false
local mayprint = aoc.mayprint

local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local tunp = aoc.tunp
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function parse(input)
    local a = tonumber(input:match("Register A: (%d+)\n"))
    local b = tonumber(input:match("Register B: (%d+)\n"))
    local c = tonumber(input:match("Register C: (%d+)\n"))

    local program = ssplit(input:match("Program: ([^\n]+)\n"))
    return a, b, c, program
end

local ADV = 0
local BXL = 1
local BST = 2
local JNZ = 3
local BXC = 4
local OUT = 5
local BDV = 6
local CDV = 7

local I2C = {
    [0] = "ADV",
    [1] = "BXL",
    [2] = "BST",
    [3] = "JNZ",
    [4] = "BXC",
    [5] = "OUT",
    [6] = "BDV",
    [7] = "CDV",
}


local function run(input)
    print("RUN: \n" .. input)

    local a, b, c, program = parse(input)
    local out = {}
    local pc = 1

    local get_literal = function()
        return program[pc + 1]
    end

    local get_combo = function()
        local operand = program[pc + 1]
        print("combo from", operand)
        if operand <= 3 and operand >= 0 then
            return operand
        elseif operand == 4 then
            return a
        elseif operand == 5 then
            return b
        elseif operand == 6 then
            return c
        else
            assert(false, "unknown operand" .. tostring(operand))
        end
    end

    while true do
        local inst = program[pc]
        print("inst: ", I2C[inst], inst, "at", pc)
        if not inst then break end

        if inst == ADV then
            local op = get_combo()
            print("a", a)
            print("combo", op)
            a = a >> op
            print("res", a)
            pc = pc + 2

        elseif inst == BXL then
            local lit = get_literal()
            print("lit", lit)
            b = b ~ lit
            print("res", b)
            pc = pc + 2

        elseif inst == BST then
            local combo = get_combo()
            print("combo", combo)
            b = combo & 0x7
            print("res", b)
            pc = pc + 2

        elseif inst == JNZ then
            if a == 0 then
                print("skip")
                pc = pc + 2
            else
                local lit = get_literal()
                print("lit", lit)
                pc = lit + 1
            end

        elseif inst == BXC then
            b = b ~ c
            print("res", b)
            pc = pc + 2

        elseif inst == OUT then
            local combo = get_combo()
            print("combo", combo)
            tins(out, combo & 0x7)
            print("out", combo & 0x7)
            pc = pc + 2

        elseif inst == BDV then
            local op = get_combo()
            print("combo", op)
            b = a >> op
            print("res", b)
            pc = pc + 2

        elseif inst == CDV then
            local op = get_combo()
            print("combo", op)
            c = a >> op
            print("res", c)
            pc = pc + 2

        else
            assert(false, "unknown intr: " .. tostring(inst))
        end

    end

    local output = tcon(out, ",")
    print(output)
    return a, b, c, output
end

local input, a, b, c, out
-- input =
-- [[
-- Register A: 0
-- Register B: 0
-- Register C: 9

-- Program: 2,6
-- ]]

-- a, b = run(input)
-- assert(b == 1)

-- input =
-- [[
-- Register A: 10
-- Register B: 0
-- Register C: 0

-- Program: 5,0,5,1,5,4
-- ]]

-- a, b, c, out = run(input)
-- assert(out == "0,1,2")

print("----- DEBUG ------ ")

input =
[[
Register A: 2024
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
]]

a, b, c, out = run(input)
assert(a == 0)
assert(out == "4,2,5,6,7,7,7,7,3,1,0")

input =
[[
Register A: 0
Register B: 29
Register C: 0

Program: 1,7
]]

a, b, c, out = run(input)
assert(b == 26)

input =
[[
Register A: 0
Register B: 2024
Register C: 43690

Program: 4,0
]]

a, b, c, out = run(input)
assert(b == 44354)

input =
[[
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
]]

a, b, c, out = run(input)
assert(out == "4,6,3,5,6,3,5,2,1,0")

input =
[[
Register A: 38610541
Register B: 0
Register C: 0

Program: 2,4,1,1,7,5,1,5,4,3,5,5,0,3,3,0
]]

a, b, c, out = run(input)
assert(out == "7,5,4,3,4,5,3,4,6")
