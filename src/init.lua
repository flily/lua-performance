
local M = {
    cases = {},
    index = {},
    all_names = {},
}

function M.load(name)
    local m = require(name)
    local l = #M.cases

    if "table" ~= type(m) then
        error(string.format("Invalid data type returned from test '%s', a table is required.", name))
    end

    if nil == m.name then
        error(string.format("Miss 'name' in test '%s'", name))
    end

    if nil == m.desc then
        error(string.format("Miss 'desc' in test '%s'", name))
    end

    if nil == m.cases then
        error(string.format("Miss 'desc' in test '%s'", name))
    end

    M.cases[l + 1] = m
    M.all_names[l + 1] = m.name
    M.index[m.name] = m 
end

function M.each()
    local n = 0
    local l = #M.cases
    return function()
        n = n + 1
        if n <= l then
            return n, M.cases[n]
        end
    end
end

function M.fetch(name)
    return M.index[name]
end

local load_list = {
    "function-call",
    "function-localize",
    "meta-function",
    "multi-conditions",
    "name-length",
    "set-default-value",
    "table-append",
    "tail-recursion",
}

for _, name in ipairs(load_list) do
    M.load(name)
end

return M
