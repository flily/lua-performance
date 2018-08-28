#!/usr/bin/lua

require 'test'

local states = {
    "alabama",          "alaska",       "arizona",          "arkansas",
    "california",       "colorado",     "connecticut",      "delaware",
    "florida",          "georgia",      "hawaii",           "idaho",
    "illinois",         "indiana",      "iowa",             "kansas",
    "kentucky",         "louisiana",    "maine",            "maryland",
    "massachusetts",    "michigan",     "minnesota",        "mississippi",
    "missouri",         "montana",      "nebraska",         "nevada",
    "new hampshire",    "new jersey",   "new mexico",       "new york",
    "north carolina",   "north dakota", "ohio",             "oklahoa",
    "oregon",           "pennsylvania", "rhode island",     "south carolina",
    "south dakota",     "tennessee",    "texas",            "utah",
    "vermont",          "virginia",     "washington",       "west virginia",
    "wisconsin",        "wyoming",
}

function to_upper(s)
    return string.upper(s)
end

local function to_upper_l(s)
    return string.upper(s)
end

function gloal_func()
    local str = ""
    for _, s in pairs(states) do
        str = str .. string.upper(s)
    end
end

function global_wrap()
    local str = ""
    for _, s in pairs(states) do
        str = str .. to_upper(s)
    end
end

function local_wrap()
    local str = ""
    for _, s in pairs(states) do
        str = str .. to_upper_l(s)
    end
end

function from_meta()
    local str = ""
    for _, s in pairs(states) do
        str = str .. s:upper()
    end
end

function localize()
    local str = ""
    local upper = string.upper
    for _, s in pairs(states) do
        str = str .. upper(s)
    end
end

local cases = {
    { name = "Global function", code = gloal_func,  t = {} },
    { name = "Global wrap    ", code = global_wrap, t = {} },
    { name = "Local wrap     ", code = local_wrap,  t = {} },
    { name = "From meta table", code = from_meta,   t = {} },
    { name = "Localize       ", code = localize,    t = {} }
}

dotest(cases, dotimes(100, 2))
