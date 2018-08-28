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

function use_or()
    local x = 0
    for _, v in pairs(states) do
        if "alabama" == v or
            "california" == v or
            "missouri" == v or
            "virginia" == v or
            "wisconsin" == v then
            x = x + 1
        end
    end
    return x
end

function use_table()
    local x, vals = 0, {"alabama", "california", "missouri", "virginia", "wisconsin"}
    for _, v in pairs(states) do
        for _, s in pairs(vals) do
            if s == v then x = x + 1 end
        end
    end
    return x
end

local cases = {
    { name = "Use OR   ", code = use_or,  t = {} },
    { name = "Use table", code = use_table, t = {} }
}

dotest(cases, dotimes(100, 10))
