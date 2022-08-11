-- Full documentation: https://github.com/openresty/lua-nginx-module#nginx-api-for-lua
local req_body = nil
local function uhttpd_recv_all()
    local content = "";
    repeat
        local rlen, rbuf = uhttpd.recv(env.CONTENT_LENGTH or 4096)
        if rlen >= 0 and rbuf ~= nil then
            content = content .. rbuf
        end
    until (rlen >= 0)
    return content
end

local function uhttpd_urlencode(plaintext)
    return string.gsub(uhttpd.urlencode(plaintext), " ", "+")
end

local function uhttpd_urldecode(urlencoded)
    return string.gsub(uhttpd.urldecode(urlencoded), "%+", " ")
end

local function parse_form_data(form_data)
    local parsed = {}
    for form_item in string.gmatch(form_data, "[^&]+") do
        local item_parts = string.gmatch(form_item, "[^=]+")
        local item_key, item_value = item_parts(), item_parts()
        if item_key then
            parsed[uhttpd_urldecode(item_key)] = uhttpd_urldecode(item_value or "");
        end
    end
    return parsed
end

local function get_name_status(status)

    local states = {
        s404 = " Not Found",
        s500 = " Internal Server Error",
        s405 = " Method Not Allowed",
        s403 = " Forbidden",
        s200 = " OK"
    }

    return states["s" .. status] or states.s404
end

ngx = {}
ngx.ctx = {}
ngx.var = {
    request_method = env.REQUEST_METHOD,
    request_uri = env.PATH_INFO,
    server_addr = env.SERVER_ADDR,
    server_port = env.SERVER_PORT,
    scheme = env.HTTPS and "https" or "http",
    remote_addr = env.REMOTE_ADDR,
    http_host = env.HTTP_HOST,
    host = env.HTTP_HOST,
    http_referer = env.HTTP_HOST,
    args = env.QUERY_STRING,
    content_type = env.CONTENT_TYPE
}
ngx.req = {
    read_body = function()
        if env.CONTENT_TYPE == "application/x-www-form-urlencoded" and not req_body then
            req_body = uhttpd_recv_all()
            return req_body
        end
        return ""
    end,
    get_body_data = function()
        return req_body or ""
    end,
    get_headers = function()
        return env.headers
    end,
    get_post_args = function(max)
        return req_body and parse_form_data(req_body) or {}
    end,
    get_uri_args = function(max)
        return env.QUERY_STRING and parse_form_data(env.QUERY_STRING) or {}
    end,
    socket = function()
        return nil, "module uhttpd socket not supported"
    end
}
ngx.update_time = function()

end
ngx.now = function()
    return os.clock()
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

