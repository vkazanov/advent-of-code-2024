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
                              return ch
    end)


    local pq = PQ.new()
    pq:enqueue({spos, aoc.RIGHT}, 0)

    local seen = {}

    assert(#pq > 0)

    local pd, s = pq:dequeue()
    local p, d = tunp(pd)

    local best_score
    while true do
        mayprint(p, d, s)

        local k = tostring(p) .. ":" .. tostring(d)
        mayprint(p, d, s)

        local next_ps = {p + d, p, p, p}
        local next_ds = {d, d:rot_clock(), d:rot_counter(), d:rot_clock():rot_clock()}
        local next_diffs = {1, 1000, 1000, 2000}

        if p == epos then
            best_score = best_score and math.min(best_score, s) or s
            goto continue
        end

        if seen[k] and seen[k] <= s then goto continue end
        seen[k] = s

        for p_i, next_p in ipairs(next_ps) do
            local next_d = next_ds[p_i]
            local next_s = s + next_diffs[p_i]
            if m[next_p] == "." then pq:enqueue({next_p, next_d}, next_s) end
        end


        ::continue::
        if #pq == 0 then break end

        pd, s = pq:dequeue()
        p, d = tunp(pd)
    end

    return best_score
end

do
    local t = [[
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
]]
    assert(find_score(t:gmatch("([^\n]+)")) == 7036)
end

do
    local t = [[
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
]]
    assert(find_score(t:gmatch("([^\n]+)")) == 11048)
end

do
    -- aoc.PRINT = true
    print(find_score(aoc.flines()))
end
