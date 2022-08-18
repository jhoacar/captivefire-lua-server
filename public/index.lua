#!/usr/bin/lua

local function serve_static_files(env)

    local folder = env.SCRIPT_FILENAME:gsub('/index.lua', '')
    local file_name = folder .. env.PATH_INFO
    local extension = env.PATH_INFO:match("^.+%.(.+)$")
    local status_code = 404
    local status_message = "Not Found"
    local content_type = "html"

    local handler = io.popen("cat " .. file_name)
    local content = handler:read("*all")
    handler:close()
    
    if #content > 0 then
        status_code = 200
        status_message = "OK"
        content_type = extension
    else
        content = "<head><title>Not Found</title></head><h1>Not Found</h1>"
    end

    uhttpd.send("Status: " .. status_code .. " " .. status_message .. "\r\n")
    uhttpd.send("Content-Type: text/" .. (content_type or "html"))
    uhttpd.send("\r\n\r\n")
    uhttpd.send(content)
end

function handle_request(env)

    if env.PATH_INFO:match('luci%-static') then
        serve_static_files(env)
    else
        loadfile('/app/build/captivefire.luac')()
        require('kernel')(env)
    end
end
