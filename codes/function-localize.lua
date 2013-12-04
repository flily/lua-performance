#!/usr/bin/lua

require 'test'

function nonlocal()
    local x = 0
    for i = 1, 100 do
        x = x + math.sin(i)
    end
    return x
end

local sin = math.sin
function localized()
    local x = 0
    for i = 1, 100 do
        x = x + sin(i)
    end
    return x
end

local cases = {
    { name = "Non-local", code = nonlocal,  t = {} },
    { name = "Localized", code = localized, t = {} }
}

dotest(cases, dotimes(200, 2))
