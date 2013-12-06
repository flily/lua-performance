#!/usr/bin/lua

require 'test'

function fact_normal(x)
    local result = 1
    for i = 2, x do
        result = result * i
    end
    return result
end

function fact_recurse(x)
    if x <= 1 then return 1 end
    return x * fact_recurse(x - 1)
end

function fact_tail(x, r)
    local result = r or 1
    if x <= 1 then return result end
    return fact_tail(x - 1, result * x)
end

function normal_recurse()
    local sum = 0
    for i = 1, 50 do
        sum = sum + fact_recurse(i)
    end
    return sum
end

function normal_loop()
    local sum = 0
    for i = 1, 50 do
        sum = sum + fact_normal(i)
    end
    return sum
end

function tail_recurse()
    local sum = 0
    for i = 1, 50 do
        sum = sum + fact_tail(i)
    end
    return sum
end

local cases = {
    { name = "Normal recurse", code = normal_recurse,  t = {} },
    { name = "Normal loop   ", code = normal_loop, t = {} },
    { name = "Tail recurse  ", code = tail_recurse, t = {} }
}

-- for i = 1, 50 do
--     local x1 = fact_normal(i)
--     local x2 = fact_recurse(i)
--     local x3 = fact_tail(i)
--     if x1 == x2 and x2 == x3 then
--         print(x1)
--     else
--         print(x1, x2, x3)
--     end
-- end
dotest(cases, dotimes(30, 20))
