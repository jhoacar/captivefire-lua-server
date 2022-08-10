-- https://github.com/openresty/lua-nginx-module#nginx-api-for-lua

local nixio = require "nixio"

local env = nixio.getenv()

local renv = {
    CONTENT_LENGTH = env.CONTENT_LENGTH,
    CONTENT_TYPE = env.CONTENT_TYPE,
    REQUEST_METHOD = env.REQUEST_METHOD,
    REQUEST_URI = env.REQUEST_URI,
    PATH_INFO = env.PATH_INFO,
    SCRIPT_NAME = env.SCRIPT_NAME:gsub("/+$", ""),
    SCRIPT_FILENAME = env.SCRIPT_NAME,
    SERVER_PROTOCOL = env.SERVER_PROTOCOL,
    QUERY_STRING = env.QUERY_STRING,
    DOCUMENT_ROOT = env.DOCUMENT_ROOT,
    HTTPS = env.HTTPS,
    REDIRECT_STATUS = env.REDIRECT_STATUS,
    REMOTE_ADDR = env.REMOTE_ADDR,
    REMOTE_NAME = env.REMOTE_NAME,
    REMOTE_PORT = env.REMOTE_PORT,
    REMOTE_USER = env.REMOTE_USER,
    SERVER_ADDR = env.SERVER_ADDR,
    SERVER_NAME = env.SERVER_NAME,
    SERVER_PORT = env.SERVER_PORT
}

ngx = {}
ngx.ctx = {}
ngx.var = {
    request_method = renv.REQUEST_METHOD,
    request_uri = renv.REQUEST_URI,
    server_addr = renv.SERVER_ADDR,
    server_port = renv.SERVER_PORT,
    scheme = renv.SERVER_PROTOCOL,
    remote_addr = renv.REMOTE_ADDR,
    http_host = renv.SERVER_NAME,
    host = renv.SERVER_NAME,
    http_referer = renv.SERVER_ADDR,
    args = renv.QUERY_STRING

}
ngx.req = {
    read_body = function()

    end,
    get_body_data = function()

    end,
    get_headers = function()
        return {""}
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
ngx.header = {}
ngx.status = 200
ngx.print = function(content)
    io.write("Status: " .. ngx.status .. "OK" .. "\r\n")
    io.write("Content-Type: text/html\r\n\r\n")
    io.write(content)
end

