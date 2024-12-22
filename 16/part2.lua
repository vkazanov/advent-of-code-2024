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

    m:print()

    local prev_m = {}
    local min_score = math.maxinteger

    do
        local pq = PQ.new()
        local p, d, prev_k = spos, aoc.RIGHT, tostring(spos) .. ":" .. tostring(aoc.RIGHT)
        pq:enqueue({p, d, prev_k}, 0)

        local seen_min_score = {}

        while true do
            if #pq == 0 then break end

            local pd, s = pq:dequeue()
            if min_score < s then goto continue end

            assert(m[p] == ".")

            p, d, prev_k = tunp(pd)
            local k = tostring(p) .. ":" .. tostring(d)
            if p == epos then
                if not prev_m[k] then
                    prev_m[k] = {}
                end
                prev_m[k][prev_k] = true
                if not min_score then min_score = s end
                print("-> end with score", s)
                goto continue
            end

            if not seen_min_score[k] then seen_min_score[k] = math.maxinteger end
            local k_min_score = seen_min_score[k]
            if k_min_score < s then goto continue end
            if k_min_score == s then
                prev_m[k][prev_k] = true
                goto continue
            end
            if k_min_score > s then
                seen_min_score[k] = s
                prev_m[k] = {}
            end
            prev_m[k][prev_k] = true

            local next_ps, next_ds, next_diffs
            next_ps = {p + d, p, p, p}
            next_ds = {d, d:rot_clock(), d:rot_counter(), d:rot_clock():rot_clock()}
            next_diffs = {1, 1000, 1000, 1000 + 1000}

            for p_i, next_p in ipairs(next_ps) do
                local next_d = next_ds[p_i]
                local next_s = s + next_diffs[p_i]
                if m[next_p] == "." then
                    -- mayprint("next", next_p, next_d)
                    pq:enqueue({ next_p, next_d, k}, next_s)
                end
            end

            ::continue::
        end
    end
    print("orig min score: ", min_score)

    local seen = {}
    do
        local dss = { aoc.UP, aoc.DOWN, aoc.LEFT, aoc.RIGHT }
        local stack = { epos }
        while #stack > 0 do
            local p = trem(stack)
            if seen[p] then goto continue end
            seen[p] = true
            if p == aoc.vec{130, 15} then print("checking", p) end

            for _, d in ipairs(dss) do
                local k = tostring(p) .. ":" .. tostring(d)
                local prev_k_set = prev_m[k] or {}
                for prev_k, _ in pairs(prev_k_set) do
                    local x, y = string.match(prev_k, "([%d-]+),([%d-]+):")
                    local prev_p = aoc.vec { x, y }

                    if p == aoc.vec{130, 15} then print(k, "prev_k:", prev_p, prev_k) end
                    mayprint("", k, "from", prev_k)

                    tins(stack, prev_p)
                end
            end

            ::continue::
        end

    end

    local count = 0
    for _, _ in pairs(seen) do count = count + 1 end

    m:print(function(ch, x, y)
        if seen[aoc.vec { x, y }] then
            return "O"
        end
        return ch
    end)

    return count, min_score
end

do
    local t = [[
####
#.E#
#S.#
####
]]
    local places, score = find_score(t:gmatch("([^\n]+)"))
    assert(places == 3, places)
    assert(score == 1002, score)
end

do
    local t = [[
#######
##...E#
#.....#
#.....#
#S#...#
#######
]]
    local places, _ = find_score(t:gmatch("([^\n]+)"))
    assert(places == 12, places)
end


do
    local t = [[
#####
#E..#
###.#
#S..#
#####
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 7, score)
end

do
    local t = [[
#####
#..E#
#..##
#S.##
#####
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 7, score)
end

do
    local t = [[
#####
#..E#
#.#.#
#S..#
#####
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 5, score)
end

do
    local t = [[
######
#....#
#S##E#
#....#
######
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 10, score)
end

do
    aoc.PRINT = true
    local t = [[
######
#....#
#S.#E#
#....#
######
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 11, score)
    aoc.PRINT = false
end

do
    local t = [[
######
#....#
#..#.#
#S.#E#
#..#.#
#....#
######
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 17, score)
end

do
    local t = [[
######
#....#
#..#.#
#S.#.#
#..#E#
#....#
######
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 9, score)
end

do
    local t = [[
########
#..OOOE#
###O#O##
#OOO#O##
#O#O#O##
#OOOOO##
#O###.##
#S..#.##
########
]]
    local score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 20, score)
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
    local places, score = find_score(t:gmatch("([^\n]+)"))
    assert(places == 45, places)
    assert(score == 7036, places)
end

do
    -- aoc.PRINT = true
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
    local places, score = find_score(t:gmatch("([^\n]+)"))
    assert(places == 64, places)
    assert(score == 11048, places)
    -- aoc.PRINT = false
end

do
    local t = [[
######################
#..#................E#
##.#.#.#####.###.#.#.#
##.#.#.........#...#.#
##.###############.#.#
#........#.......#.#.#
########.#.#####.###.#
#S.........#.........#
######################
]]
    local places = find_score(t:gmatch("([^\n]+)"))
    assert(places == 30)
end

do
    aoc.PRINT = true
    local t = [[
################
######E#######.#
#.OOOOOOOOOOO#.#
##O#.###.###O###
##O#.....#.#OOO#
##O#######.###O#
#.OOOOOOOOOOOOO#
##.#.#O#O#O#O###
#..#.#OOOOOOOS##
################
]]
    local places, score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 7022, score)
    assert(places == 32, places)
    aoc.PRINT = false
end

do
    aoc.PRINT = true
    local t = [[
#######
#EOOOO#
###O#O#
###OOO#
#####O#
#####O#
#####O#
#####S#
#######
]]
    local places, score = find_score(t:gmatch("([^\n]+)"))
    assert(score == 2010, score)
    assert(places == 11, places)
    aoc.PRINT = false
end

do
    local t = [[
#############
##S##########
#.OOOOO.....#
##O###O###.##
#.O#..O#...##
##O###O#.####
#.OOO#O#....#
##O#O#O######
#.O#OOOOOOOE#
##O#O#####.##
##O#O#...#.##
##O#O#.#.####
#.OOO#.#....#
#############
]]
    local places, score = find_score(t:gmatch("([^\n]+)"))
    assert(places == 37, places)
    assert(score == 4016, score)
end

do
    -- aoc.PRINT = true
    -- 606 -> too high
    -- 656 -> too high
    -- 445 -> too low
    local places, score = find_score(aoc.flines())
    assert(score == 95444, score)
    print(places)
end
