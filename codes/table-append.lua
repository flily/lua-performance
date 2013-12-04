#!/usr/bin/lua

require 'test'

function table_insert()
    local t = {}
    for i = 1, 1000, 2 do
        table.insert(t, i)
    end
    return t
end

function table_insertL()
    local t, insert = {}, table.insert
    for i = 1, 1000, 2 do
        insert(t, i)
    end
    return t
end

function use_counter()
    local t, c = {}, 1
    for i = 1, 1000, 2 do
        t[c], c = i, c + 1
    end
    return t
end

function use_length()
    local t = {}
    for i = 1, 1000, 2 do
        t[#t + 1] = i
    end
end

local cases = {
    { name = "table.insert G", code = table_insert,  t = {} },
    { name = "table.insert L", code = table_insertL,  t = {} },
    { name = "use counter   ", code = use_counter, t = {} },
    { name = "use length    ", code = use_length, t = {} },
}

dotest(cases, dotimes(10, 5))
