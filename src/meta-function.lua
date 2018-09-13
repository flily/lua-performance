#!/usr/bin/lua

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

return {
    name = "meta-function",
    desc = "implement with meta-function",
    cases = {
        { name = "Global function", entry = gloal_func },
        { name = "Global wrap    ", entry = global_wrap },
        { name = "Local wrap     ", entry = local_wrap },
        { name = "From meta table", entry = from_meta },
        { name = "Localize       ", entry = localize },
    },
}
