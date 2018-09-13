#!/usr/bin/env lua

--[[
Main entry to launch test cases.
--]]


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
    for i = 1, times or 100000 do
        func()
    end
    local endtm = os.clock()
    return round(endtm - begin)
end
  
  
function dotest(cases, times)
    for i = 1, #cases do
        local case = cases[i]
        io.stdout:write(string.format("Case %d: %s ", i, case.name))

        case.t = {}
        for j = 1, 5 do
            io.stdout:write(".")
            io.stdout:flush()
            collectgarbage()
            local runtime = runtest(case.entry, times)
            case.t[#case.t + 1] = runtime
        end
        print()
    end

    print("ID", "Case name", "t1", "t2", "t3", "t4", "t5", "avg.", "%")
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


local function check_enviroment()
    local is_luajit = not (nil == jit)
    local o = {
        ["Syntax version"] = _VERSION,
        ["Is LuaJIT"] = is_luajit,
        ["LuaJIT version"] = is_luajit and jit.version or "No LuaJIT",
    }

    return o
end


local function load_test_case()
    package.path = package.path .. ";./src/?.lua"
    local cases = require "src.init"

    return cases
end


local function usage(interpreter, executable)
    print("Usage:")
    print(string.format("  %s %s command [args...]",
          interpreter, executable))
    print()
    print("Commands:")
    print("  env               Show lua environment information.")
    print("  list              List all test cases.")
    print("  run [cases ...]   Run test cases given. Run all cases if args is missing.")
end


local function cmd_do_env()
    local env_info = check_enviroment()

    print("Environment information:")
    for k, v in pairs(env_info) do
        print(string.format("  - %s: %s", k, v))
    end
end


local function cmd_do_list()
    local cases = load_test_case()
    local title = string.format(" %4s %-20s    %-60s    %s",
                                "No.", "Name", "Description", "Count of cases")
    local l = string.rep("-", 1 + #title)
    print(title)
    print(l)

    for i, m in cases.each() do
        print(string.format(" %4d %-20s    %-60s    %d", i, m.name, m.desc, #m.cases))
    end
end


local function cmd_do_run(names)
    local cases = load_test_case()
    local env_info = check_enviroment()
    local run_all = false

    if #names <= 0 or names[1] == "all" then
        names = cases.all_names
    end

    print("Running environment")
    print(string.format("Lua syntax version %s, LuaJIT=%s",
                        env_info["Syntax version"], env_info["Is LuaJIT"]))
    print(string.rep("=", 60))


    for _, name in ipairs(names) do
        local c = cases.fetch(name)
        if nil == c then
            print(string.format("Test case '%s' not found", name))

        else
            local entries = c.cases
            print(string.format("Running test '%s' ......", c.name))
            dotest(entries)
        end
    end
end


local function main()
    if nil == arg[1] then
        usage(arg[-1], arg[0])
        return
    end

    local cmd = arg[1]
    if "env" == cmd then
        cmd_do_env()
    elseif "list" == cmd then
        cmd_do_list()
    elseif "run" == cmd then
        local names = {}
        for i = 2, #arg, 1 do
            names[i - 1] = arg[i]
        end
        cmd_do_run(names)
    end
end


main()
