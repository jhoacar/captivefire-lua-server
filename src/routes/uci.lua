local controller = require("controllers.uci")
local UciRoute = {
    before = function(self)
        -- do something before this route
    end,
    GET = controller.get,
    POST = controller.post
}

return UciRoute
