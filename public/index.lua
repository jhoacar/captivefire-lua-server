#!/usr/bin/lua

-- Main execution thread
io.write("Status: 200 OK\r\n")
io.write("Content-Type: text/plain\r\n\r\n")
local util = require("luci.util")

local function run()
    local x = coroutine.create(init)
    local res = coroutine.resume(x, error_handler)
end

function init()
    local response
    local stat, err = util.coxpcall(function()
        local kernel = require("captivefire")
        response = kernel.dispatch()
    end, error_handler)

    show(response);

end

function show(message)

    io.write(tostring(message) .. "\n")
    return false
end

function error_handler(message)
    -- io.write("Status: 500 Internal Server Error\r\n")
    -- io.write("Content-Type: text/plain\r\n\r\n")
    io.write(message)
    return false
end

-- run()
