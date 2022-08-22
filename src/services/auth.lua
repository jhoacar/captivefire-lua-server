local curl = require("util.curl")

local AuthService = {}

function AuthService.is_authorized(self)
    if not self.req.headers.authorization then
        return false
    end
    local authorization = self.req.headers['authorization']
    local token = authorization:match('^Bearer%s([%w%p]*)$')

    if not token then
        return false
    end

    local url = env.CAPTIVEFIRE_ACCESS .. '/openwrt'
    local options = {
        method = "POST",
        headers = {
            ["Authorization"] = "Bearer " .. token
        }
    }
    local body, code, headers, status = curl.fetch(url, options)

    return code == 202
end

function AuthService.handle_authorized(self)
    return nil
end

return AuthService
