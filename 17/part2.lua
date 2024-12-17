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


local function run(input, a_override, target_output)
    mayprint("RUN: \n" .. input)

    local a, b, c, program = parse(input)
    local out = {}
    local pc = 1

    if a_override then a = a_override end

    local get_literal = function()
        return program[pc + 1]
    end

    -- Combo operands 0 through 3 represent literal values 0 through 3.
    -- Combo operand 4 represents the value of register A.
    -- Combo operand 5 represents the value of register B.
    -- Combo operand 6 represents the value of register C.
    -- Combo operand 7 is reserved and will not appear in valid programs.

    local get_combo = function()
        local operand = program[pc + 1]
        mayprint("combo from", operand)
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

    local res_i = 1
    local check = function(res)
        if not target_output then return true end
        local target_res = target_output[res_i]
        print("check res", res, "vs target", target_res)
        res_i = res_i + 1
        return true -- target_res == res
        -- return target_res == res
    end

    while true do
        local inst = program[pc]
        mayprint("inst: ", I2C[inst], inst, "at", pc)
        if not inst then break end

        -- The adv instruction (opcode 0) performs division. The numerator is the value in
        -- the A register. The denominator is found by raising 2 to the power of the
        -- instruction's combo operand. (So, an operand of 2 would divide A by 4 (2^2); an
        -- operand of 5 would divide A by 2^B.) The result of the division operation is
        -- truncated to an integer and then written to the A register.

        -- 0
        if inst == ADV then
            local op = get_combo()
            mayprint("a", a)
            mayprint("combo", op)
            a = a >> op
            mayprint("res", a)
            pc = pc + 2

        -- The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the
        -- instruction's literal operand, then stores the result in register B.

        -- 1
        elseif inst == BXL then
            local lit = get_literal()
            mayprint("lit", lit)
            b = b ~ lit
            mayprint("res", b)
            pc = pc + 2

        -- The bst instruction (opcode 2) calculates the value of its combo operand modulo
        -- 8 (thereby keeping only its lowest 3 bits), then writes that value to the B
        -- register.

        -- 2
        elseif inst == BST then
            local combo = get_combo()
            mayprint("combo", combo)
            b = combo & 0x7
            mayprint("res", b)
            pc = pc + 2

        -- The jnz instruction (opcode 3) does nothing if the A register is 0. However, if
        -- the A register is not zero, it jumps by setting the instruction pointer to the
        -- value of its literal operand; if this instruction jumps, the instruction
        -- pointer is not increased by 2 after this instruction.

        -- 3
        elseif inst == JNZ then
            if a == 0 then
                mayprint("skip")
                pc = pc + 2
            else
                local lit = get_literal()
                mayprint("lit", lit)
                pc = lit + 1
            end

        -- The bxc instruction (opcode 4) calculates the bitwise XOR of register B and
        -- register C, then stores the result in register B. (For legacy reasons, this
        -- instruction reads an operand but ignores it.)

        -- 4
        elseif inst == BXC then
            b = b ~ c
            mayprint("res", b)
            pc = pc + 2

        -- The out instruction (opcode 5) calculates the value of its combo operand modulo
        -- 8, then outputs that value. (If a program outputs multiple values, they are
        -- separated by commas.)

        -- 5
        elseif inst == OUT then
            local combo = get_combo()
            mayprint("combo", combo)
            local res = combo & 0x7

            if not check(res) then
                return false
            end

            tins(out, res)
            mayprint("out", res)
            pc = pc + 2

        -- 6
        elseif inst == BDV then
            local op = get_combo()
            mayprint("combo", op)
            b = a >> op
            mayprint("res", b)
            pc = pc + 2

        -- The cdv instruction (opcode 7) works exactly like the adv instruction except
        -- that the result is stored in the C register. (The numerator is still read from
        -- the A register.)

        -- 7
        elseif inst == CDV then
            local op = get_combo()
            mayprint("combo", op)
            c = a >> op
            mayprint("res", c)
            pc = pc + 2

        else
            assert(false, "unknown intr: " .. tostring(inst))
        end

    end

    local output = tcon(out, ",")
    mayprint("OUTPUT: ", output)
    return #out == #target_output, a, b, c, output
end

local input, is_success, a, b, c, out

-- aoc.PRINT = false
-- input =
-- [[
-- Register A: 2024
-- Register B: 0
-- Register C: 0

-- Program: 0,3,5,4,3,0
-- ]]

-- is_success, a, b, c, out = run(input, 2024, { 0, 3, 5, 4, 3, 0 })
-- assert(not is_success)

-- is_success, a, b, c, out = run(input, 117440, { 0, 3, 5, 4, 3, 1 })
-- assert(not is_success)

-- is_success, a, b, c, out = run(input, 117440, { 0, 3, 5, 4, 3, 0 })
-- assert(is_success)
-- assert(out == "0,3,5,4,3,0")

print("---- FINAL ---- ")

input =
[[
Register A: 38610541
Register B: 0
Register C: 0

Program: 2,4,1,1,7,5,1,5,4,3,5,5,0,3,3,0
]]

-- 2,4 | 1,1 | 7,5 | 1,5 | 4,3 | 5,5 | 0,3 | 3,0
--
-- 2, 4 -> bst A -> B = A & 7 (take lowest 3 bits from A)
-- 1, 1 -> bxl 1 -> B = B ~ 1 (switch 1st bit)
-- 7, 5 -> cdv B -> C = A >> B (divide A by 2^B)
-- 1, 5 -> bxl B -> B = B ~ 5 (switch 1st and 3rd bits)
-- 4, 3 -> bxc -> B = B ~ C (xor B and C)

-- 5, 5 -> out B -> output B & 0x7
-- 0, 3 -> adv 3 -> A = A >> 3 (divide A by 2**3)
-- 3, 0 -> jnz 0 -> start again if A != 0

local target_out = { 2, 4, 1, 1, 7, 5, 1, 5, 4, 3, 5, 5, 0, 3, 3, 0 }

local a = 0x0
local function find(a, out_i)
    if out_i < 1 then print(a); return end
    local o = target_out[out_i]
    if not o then return end

    local work_a, b, c
    for work_a = 0, 0x7 do
        tmp_a = (a << 3) + work_a
        b = tmp_a & 7
        b = b ~ 1
        c = tmp_a >> b
        b = b ~ 5
        b = b ~ c
        local out = b & 0x7
        if out == o then find(tmp_a, out_i - 1) end
    end
end
find(0, 16)

-- local a_init = 164278899142333
-- is_success, a, b, c, out = run(input, a_init, target_out)
-- print(out)
-- print(is_success)
