local controller = require("controllers.luci")
local LuciRoute = {
    before = function(self)
        -- do something before this route
    end,
    GET = controller.get,
    POST = controller.post
}

return LuciRoute

