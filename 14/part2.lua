local aoc = require "aoc"

aoc.PRINT = false
local mayprint = aoc.mayprint

-- TODO: rename positions into vectors
local vec = aoc.vec
local tins = aoc.tins
local tcon = aoc.tcon
local trem = aoc.trem
local ssplit = aoc.str_split
local arreq = aoc.arr_eq

local function sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

local function mapprint(map, dim)
    print("-------------------")
    for y = 0, dim.y do
        for x = 0, dim.y do
            io.write(map[x .. "," .. y] and "*" or " ")
        end
        io.write("\n")
    end

end

do
    local dim = vec { 101, 103 }

    local robots_pos= {}
    local robots_vel = {}
    for line in aoc.flines() do
        local nums = line:gmatch("[%d-]+")
        local p = vec { tonumber(nums()), tonumber(nums()) }
        local v = vec { tonumber(nums()), tonumber(nums()) }
        tins(robots_pos, p)
        tins(robots_vel, v)
    end


    -- local times = 126 -- too low
    -- local times = 0 -- too low
    local times = 40
    local step = 1
    local min_line_len = 6
    local min_col_len = 6
    while true do

        local map = {}
        for i, _ in ipairs(robots_pos) do
            local p = (robots_pos[i] + robots_vel[i]:times(times)):wrap(dim)
            map[tostring(p)] = true
        end

        for x = 0, dim.x - 1 do
            local cur_len = 0

            for y = 0, dim.y - 1 do
                if map[x .. "," .. y] then cur_len = cur_len + 1
                else cur_len = 0 end

                if cur_len >= min_line_len then
                    print("vertical found: ", cur_len)
                    mapprint(map, dim)
                    sleep(0.4)
                    print(times)
                    goto continue
                end
            end
        end

        for y = 0, dim.y - 1 do
            local cur_len = 0

            for x = 0, dim.x - 1 do
                if map[x .. "," .. y] then cur_len = cur_len + 1
                else cur_len = 0 end

                if cur_len >= min_col_len then
                    print("horizontal found: ", cur_len)
                    mapprint(map, dim)
                    sleep(0.4)
                    print(times)
                    goto continue
                end
            end
        end

        ::continue::
        times = times + step
    end
end
