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

    local body, code, headers, status = curl.fetch(env.CAPTIVEFIRE_ACCESS .. '/openwrt', {
        method = "POST",
        headers = {
            ["Authorization"] = "Bearer " .. token
        }
    })

    return code == 202
end

function AuthService.handle_authorized(self)
    return nil
end

package.loaded["services.auth"] = AuthService

return AuthService
