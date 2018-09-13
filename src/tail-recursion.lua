#!/usr/bin/lua

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

return {
    name = "tail-recursion",
    desc = "tail recursion or normal loop",
    cases = {
        { name = "Normal recurse", entry = normal_recurse },
        { name = "Normal loop   ", entry = normal_loop },
        { name = "Tail recurse  ", entry = tail_recurse },
    },
}

