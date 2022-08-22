local controller = require("controllers.password")
local PasswordRoute = {
    before = function(self)
        -- do something before this route
    end,
    GET = controller.get,
    POST = controller.post
}

return PasswordRoute

