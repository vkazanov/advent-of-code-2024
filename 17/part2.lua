local TARGET_OUT = { 2, 4, 1, 1, 7, 5, 1, 5, 4, 3, 5, 5, 0, 3, 3, 0 }
local function find(a, out_i)
    if out_i < 1 then print(a); return end
    local o = TARGET_OUT[out_i]
    if not o then return end

    local b, c
    for work_a = 0, 0x7 do
        local tmp_a = (a << 3) + work_a
        b = tmp_a & 7
        b = b ~ 1
        c = tmp_a >> b
        b = b ~ 5
        b = b ~ c
        local out = b & 0x7
        if out == o then find(tmp_a, out_i - 1) end
    end
end

-- prints 2 candidate answers
find(0, 16)
