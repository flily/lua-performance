#!/usr/bin/lua

require 'test'

function direct_compute()
    local x = 0
    for i = 1, 30 do
        local r = 1
        for j = 1, i do
            r = r * j
        end
        x = x + r
    end
    return x
end

function fact(x)
    local result = 1
    for i = 1, x do
        result = result * i
    end
    return result
end

function call_function()
    local x = 0
    for i = 1, 30 do
        x = x + fact(i)
    end
    return x
end

local cases = {
    { name = "Direct compute", code = direct_compute,  t = {} },
    { name = "Call function ", code = call_function, t = {} }
}

-- print(direct_compute())
-- print(call_function())
dotest(cases, dotimes(200, 10))
