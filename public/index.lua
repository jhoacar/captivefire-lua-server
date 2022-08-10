#!/usr/bin/lua

local util = require "luci.util"

local function send_error(message)
    io.write("Status: 500 Internal Server Error\r\n")
    io.write("Content-Type: text/html\r\n\r\n")
    io.write("<h1>Internal Server Error</h1>")
    local trace = util.split(message, "\n")
    local main_error = trace[1]
    io.write("<h2>" .. main_error .. "</h2>")
    for i = 2, #trace - 1 do
        io.write("<h3>" .. trace[i] .. "</h3>")
    end
end

local library = "captivefire.kernel"

local status, retval = pcall(require, library)

if status == false then
    return send_error(retval)
end

local kernel = require(library)

local status, retval = pcall(kernel.run)

if status == false then
    return send_error(retval)
end

