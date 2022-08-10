-- Main execution thread

ID_SET_STATUS = 1
ID_LOAD_HEADERS = 2
ID_SET_HEADERS = 3
ID_SET_CONTENT = 4
ID_SEND_RESPONSE = 5

local io = require "io"
local coroutine = require "coroutine"
local util = require "luci.util"
local http = require "luci.http"
local sys = require "luci.sys"
local ltn12 = require "luci.ltn12"

-- Limited source to avoid endless blocking
local function limitsource(handle, limit)
    limit = limit or 0
    local BLOCKSIZE = ltn12.BLOCKSIZE

    return function()
        if limit < 1 then
            handle:close()
            return nil
        else
            local read = (limit > BLOCKSIZE) and BLOCKSIZE or limit
            limit = limit - read

            local chunk = handle:read(read)
            if not chunk then
                handle:close()
            end
            return chunk
        end
    end
end

local function error_handler(message)
    util.perror(message)
    http.status(500, "Internal Server Error")
    http.prepare_content("text/plain")
    http.write(message)
end

local function httpdispatch(request, prefix)

    http.context.request = request

    local pathinfo = http.urldecode(request:getenv("PATH_INFO") or "", true)

    if prefix then
        for _, node in ipairs(prefix) do
            r[#r + 1] = node
        end
    end

    local node
    for node in pathinfo:gmatch("[^/%z]+") do
        r[#r + 1] = node
    end

    local stat, err = util.coxpcall(function()
        local kernel = require("captivefire")
        kernel.dispatch()
    end, error_handler)

    http.close()
end

local function run()

    local request = http.Request(sys.getenv(), limitsource(io.stdin, tonumber(sys.getenv("CONTENT_LENGTH"))),
        ltn12.sink.file(io.stderr))
    local server = coroutine.create(httpdispatch)
    local headers = ""
    local active = true
    while coroutine.status(server) ~= "dead" do
        local res, id, data1, data2 = coroutine.resume(server, request)

        if not res then
            print("Status: 500 Internal Server Error")
            print("Content-Type: text/plain\n")
            print(id)
            break
        end

        if active then
            if id == ID_SET_STATUS then
                io.write("Status: " .. tostring(data1) .. " " .. data2 .. "\r\n")
            elseif id == ID_LOAD_HEADERS then
                headers = headers .. data1 .. ": " .. data2 .. "\r\n"
            elseif id == ID_SET_HEADERS then
                io.write(headers)
                io.write("\r\n")
            elseif id == ID_SET_CONTENT then
                io.write(tostring(data1 or ""))
            elseif id == ID_SEND_RESPONSE then
                io.flush()
                io.close()
                active = false
            end
        end
    end
end

return {
    run = run
}