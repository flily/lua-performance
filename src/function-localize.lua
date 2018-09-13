
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

return {
    name = "function-localize",
    desc = "calling local/global functions",
    cases = {
        { name = "Non-local", entry = nonlocal },
        { name = "Localized", entry = localized },
    },
}
