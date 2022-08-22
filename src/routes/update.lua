local controller = require("controllers.update")
local UpdateRoute = {
    before = function(self)
        -- do something before this route
    end,
    GET = controller.get,
    POST = controller.post
}

return UpdateRoute
