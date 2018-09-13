#!/usr/bin/lua

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

return {
    name = "table-append",
    desc = "append item to a table",
    cases = {
        { name = "table.insert G", entry = table_insert },
        { name = "table.insert L", entry = table_insertL },
        { name = "use counter   ", entry = use_counter },
        { name = "use length    ", entry = use_length },
    }
}

