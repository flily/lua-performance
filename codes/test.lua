
function round(num, idp)
  local mult = 10^(idp or 3)
  return math.floor(num * mult + 0.5) / mult
end

function average(nums)
    local sum = 0
    for i = 1, #nums do sum = sum + nums[i] end
    return sum / #nums
end

function runtest(func, times)
    local begin = os.clock()
    for i = 1, times do
        func()
    end
    local endtm = os.clock()
    return round(endtm - begin)
end

function is_luajit()
    for k, v in pairs(arg) do
        if k <= 0 and v:find("luajit") then
            return true
        end
    end

    return false
end

function dotest(cases, times)
    for i = 1, #cases do
        local case = cases[i]
        io.stdout:write(string.format("Case %d: %s", i, case.name))
        for j = 1, 5 do
            io.stdout:write(".")
            collectgarbage()
            local runtime = runtest(case.code, times)
            case.t[#case.t + 1] = runtime
        end
        print()
    end
  
    print("Case ID", "Case name", "t1", "t2", "t3", "t4", "t5", "avg.", "%")
    local base = 0
    for i = 1, #cases do
        local case = cases[i]
        local t, avg = case.t, average(case.t)
        
        if i == 1 then base = avg end
        local per = avg / base
    
        print(i, case.name, t[1], t[2], t[3], t[4], t[5], avg, round(100*per,2) .. "%")
    end
    print("----------------")
end

function dotimes(t, jt)
    local basetimes = 1000
    local times = t or 1
    if is_luajit() then times = times * (jt or 100) end
    return basetimes * times
end

function show_interpreter()
    if is_luajit() then
        print("In LuaJIT")
    else
        print("In Lua")
    end
end

show_interpreter()
