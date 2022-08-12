local http = require("socket.http")
local ltn12 = require("ltn12")

local _M = {}

---@param url string
---@param options table|nil
function _M.fetch(url, options)
    if not url then
        return nil
    end
    if type(options) ~= "table" and type(options) ~= "nil" then
        return nil
    end
    local respbody = {}
    local method = options.method or "GET"
    local sink = ltn12.sink.table(respbody)
    local reqbody = type(options.body) == "string" and options.body or ""
    local headers = type(options.headers) == "table" and options.headers or {}
    return http.request {
        url = url,
        sink = sink,
        method = method,
        headers = headers,
        source = ltn12.source.string(reqbody)
    }
end

return _M
