local controller = require("controllers.portal")
local PortalRoute = {
    before = function(self)
        -- do something before this route
    end,
    GET = controller.get,
    POST = controller.post
}

package.loaded["routes.portal"] = PortalRoute

return PortalRoute
