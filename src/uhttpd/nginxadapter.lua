-- https://github.com/openresty/lua-nginx-module#nginx-api-for-lua
local function get_name_status(status)

    local states = {
        s404 = " Not Found",
        s500 = " Internal Server Error",
        s405 = " Method Not Allowed",
        s403 = " Forbidden",
        s200 = " OK"
    }
    local state = "s" .. status

    if states[state] ~= nil then
        return states[state]
    else
        return states.s404
    end
end


ngx = {}
ngx.ctx = {}
ngx.var = {
    request_method = env.REQUEST_METHOD,
    request_uri = env.REQUEST_URI,
    server_addr = env.SERVER_ADDR,
    server_port = env.SERVER_PORT,
    scheme = env.SERVER_PROTOCOL,
    remote_addr = env.REMOTE_ADDR,
    http_host = env.SERVER_NAME,
    host = env.SERVER_NAME,
    http_referer = env.SERVER_ADDR,
    args = ""

}
ngx.req = {
    read_body = function()

    end,
    get_body_data = function()

    end,
    get_headers = function()
        return env.headers
    end,
    get_post_args = function(max)

    end,
    get_uri_args = function(max)

    end
}
ngx.update_time = function()

end
ngx.now = function()

end
ngx.escape_uri = function(str, type)

end
ngx.sleep = 0
local contentType = "Content-Type"
ngx.header = {}
ngx.header[contentType] = "text/html"
ngx.status = 200
ngx.print = function(content)

    uhttpd.send("Status: " .. ngx.status .. get_name_status(ngx.status) .. "\r\n")

    for key, value in pairs(ngx.header) do
        uhttpd.send(key .. ": " .. value .. "\r\n")
    end
    uhttpd.send("\r\n\r\n")
    uhttpd.send(content)
end

