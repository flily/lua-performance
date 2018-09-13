
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

return {
    name = "function-call",
    desc = "function call vs in-line code",
    cases = {
        { name = "Direct compute", entry = direct_compute },
        { name = "Call function ", entry = call_function },
    },
}
