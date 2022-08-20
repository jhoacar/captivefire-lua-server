local http = require("socket.http")
local ltn12 = require("ltn12")

local _M = {}

function _M.fetch(url, options)
    if not url then
        return nil
    end
    if type(options) ~= "table" and type(options) ~= "nil" then
        return nil
    end
    local respbody = resp or {}
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

function _M.save_file(url, file_name, options)
    if not url then
        return nil
    end
    if type(options) ~= "table" and type(options) ~= "nil" then
        return nil
    end
    local method = options.method or "GET"
    local sink = ltn12.sink.file(io.open(file_name,"wb"))
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

package.loaded["util.curl"] = _M

return _M
