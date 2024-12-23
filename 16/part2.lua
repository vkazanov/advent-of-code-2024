local aoc = require "aoc"
local PQ = require "PriorityQueue"

aoc.PRINT = false
local mayprint = aoc.mayprint

local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local tunp = aoc.tunp
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function find_score(lines)
    local spos, epos

    local m = aoc.mappify(lines,
                          function(ch, pos)
                              if ch == "S" then spos = pos; ch = "." end
                              if ch == "E" then epos = pos; ch = "." end
                              if ch == "O" then ch = "." end
                              return ch
    end)
    assert(spos)
    assert(epos)

    local min_score = math.maxinteger

    local function key(pos, dir)
        return tostring(pos) .. ":" .. tostring(dir)
    end

    local seen2prev = {}
    local seen_score = {}
    do
        local pq = PQ.new()
        local p, d, prev_k = spos, aoc.RIGHT, key(spos, aoc.RIGHT)
        pq:enqueue({p, d, prev_k}, 0)

        while not pq:empty() do
            local pdpk, s = pq:dequeue()
            assert(m[p] == ".")

            p, d, prev_k = tunp(pdpk)
            local k = key(p, d)

            -- skip states that are not minimal in score
            if seen_score[k] and seen_score[k] < s then goto continue end
            seen_score[k] = s

            -- remember all the different paths that lead to this state
            if not seen2prev[k] then seen2prev[k] = {} end
            seen2prev[k][prev_k] = true

            -- check if end - done
            if p == epos then
                min_score = s
                break
            end

            -- next step
            local next_ps, next_ds, next_s_diff
            next_ps = {p + d, p, p}
            next_ds = {d, d:rot_clock(), d:rot_counter()}
            next_s_diff = {1, 1000, 1000}
            for i, next_p in ipairs(next_ps) do
                if m[next_p] == "." then
                    local next_d = next_ds[i]
                    local next_s = s + next_s_diff[i]
                    pq:enqueue({ next_p, next_d, k}, next_s)
                end
            end

            ::continue::
        end

        -- flush the remaining same score ends
        local pdpk, next_s = pq:peek()
        while next_s == min_score do
            local k
            p, d, prev_k = tunp(pdpk)
            k = key(p, d)
            if not seen2prev[k] then seen2prev[k] = {} end
            seen2prev[k][prev_k] = true
            pq:dequeue()
            pdpk, next_s = pq:peek()
       end
    end

    -- walk backwards
    local count = 0
    do
        local stack = { }
        local dss = { aoc.UP, aoc.DOWN, aoc.LEFT, aoc.RIGHT }
        for _, d in ipairs(dss) do tins(stack, key(epos, d)) end

        local seen_backwards = {}
        while #stack > 0 do
            local k = trem(stack)
            -- skip places not seen before
            if not seen2prev[k] then goto continue end
            if seen_backwards[k] then goto continue end

            for prev_k, _ in pairs(seen2prev[k]) do
                seen_backwards[k] = true

                if k == prev_k then goto nextprev end
                if prev_k then tins(stack, prev_k) end

                ::nextprev::
            end

            ::continue::
        end

        local seen_set = {}
        for k, _ in pairs(seen_backwards) do
            local x, y = string.match(k, "([%d-]+),([%d-]+):")
            seen_set[vec { x, y }] = true
        end
        for _, _ in pairs(seen_set) do
            count = count + 1
        end
    end

    return min_score, count
end

do
    local score, places = find_score(aoc.flines())
    assert(score == 95444, score)
    assert(places == 513)
end
