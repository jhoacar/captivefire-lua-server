local luci = require("services.luci")

local LuciController = {}

LuciController.get = function(self)
    local luci_url = self.req.parsed_url.scheme .. "://" .. self.req.parsed_url.host .. "/cgi-bin/luci"
    self.title = "Captivefire"
    return {
        render = false,
        headers = {
            ["Location"] = luci_url
        },
        status = 302
    }
end

LuciController.post = function(self)

    local enable = self.req.params_post.enable
    if enable == nil then
        return {
            json = {
                error = "field enable is missed"
            },
            status = 400
        }
    end

    local result = enable and luci.enable() or luci.disable()

    return {
        json = {
            message = result
        }
    }
end

package.loaded["controllers.luci"] = LuciController

return LuciController
