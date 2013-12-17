#!/usr/bin/lua

require 'test'

function add_or(a, b)
	local c = b or 1
	return a + c
end

function add_if(a, b)
	local c = b
	if c == nil then
		c = 1
	end

	return a + c
end

function test_or()
	local sum = 0
	for i = 1, 50 do
		sum = sum + add_or(i)
	end
	return sum
end

function test_if()
	local sum = 0
	for i = 1, 50 do
		sum = sum + add_or(i)
	end
	return sum
end

local cases = {
    { name = "Use if    ", code = test_if,  t = {} },
    { name = "Use or    ", code = test_or, t = {} },
}

dotest(cases, dotimes(200))
