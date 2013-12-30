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

a_list_of_all_names_of_united_states = ""
all_name = ""
an = ""

function global_long()
    a_list_of_all_names_of_united_states = ""
    for _, v in pairs(states) do
        a_list_of_all_names_of_united_states = a_list_of_all_names_of_united_states .. v
    end

    return a_list_of_all_names_of_united_states
end

function global_medium()
    all_name = ""
    for _, v in pairs(states) do
        all_name = all_name .. v
    end

    return all_name
end

function global_short()
    an = ""
    for _, v in pairs(states) do
        an = an .. v
    end

    return an
end

function local_long()
    local a_list_of_all_names_of_united_states = ""
    for _, v in pairs(states) do
        a_list_of_all_names_of_united_states = a_list_of_all_names_of_united_states .. v
    end

    return a_list_of_all_names_of_united_states
end

function local_medium()
    local all_name = ""
    for _, v in pairs(states) do
        all_name = all_name .. v
    end

    return all_name
end

function local_short()
    local an = ""
    for _, v in pairs(states) do
        an = an .. v
    end

    return an
end

local cases1 = {
    { name = "Global long   ", code = global_long,   t = {} },
    { name = "Global medium ", code = global_medium, t = {} },
    { name = "Global short  ", code = global_short,  t = {} }
}

local cases2 = {
    { name = "Local long    ", code = local_long,    t = {} },
    { name = "Local medium  ", code = local_medium,  t = {} },
    { name = "Local short   ", code = local_short,   t = {} }
}

dotest(cases1, dotimes(200, 2))
dotest(cases2, dotimes(200, 2))
