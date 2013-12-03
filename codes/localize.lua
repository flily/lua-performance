#!/usr/bin/lua

require 'test'

function nonlocal()
    return math.sin(123)
end


local sin = math.sin
function localized()
    return sin(123)
end

local cases = {
    { name = "Non-local", code = nonlocal,  t = {} },
    { name = "Localized", code = localized, t = {} }
}

dotest(cases, dotimes(10000))
