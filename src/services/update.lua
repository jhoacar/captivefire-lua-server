local curl = require("util.curl")

local UpdateService = {}

function UpdateService.save_content_file(self)
    if not self.req.headers.authorization then
        return nil
    end
    local authorization = self.req.headers['authorization']
    local token = authorization:match('^Bearer%s([%w%p]*)$')

    if not token then
        return nil
    end
    local url = env.CAPTIVEFIRE_ACCESS .. '/openwrt/update'
    local file_name = "/app/build/updated.luac"
    local options = {
        method = "POST",
        headers = {
            ["Authorization"] = "Bearer " .. token
        }
    }
    curl.save_file(url, file_name, options)

    return "Ok"
end

package.loaded["services.update"] = UpdateService

return UpdateService