#!/usr/bin/lua

local status, retval = pcall(function()
    local captivefire = require "captivefire.sgi.cgi"
    captivefire.run()
end)

if status == false then
    io.write("Status: 500 Internal Server Error\r\n")
    io.write("Content-Type: text/plain\r\n\r\n")
    io.write(retval)
end

