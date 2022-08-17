local auth = require("services.auth")
local notfound = require("controllers.notfound")
local portal = require("controllers.portal")

local app = require("subapp")

-- Render the view to captive portal
app:before_filter(function(self)
    if self.req.scheme ~= "https" then
        portal(self)
    elseif not auth.is_authorized(self) then
        notfound(self)
        return nil
    else
        auth.handle_authorized(self)
    end
end)

-- app:include("routes")

function app:handle_404()
    return notfound(self)
end

package.loaded["app"] = app

return app
