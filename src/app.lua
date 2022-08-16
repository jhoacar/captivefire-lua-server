local auth = require("captivefire.services.auth")
local notfound = require("captivefire.controllers.notfound")
local portal = require("captivefire.controllers.portal")

local app = require("captivefire.subapp")

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

app:include("captivefire.routes")

function app:handle_404()
    return notfound(self)
end

package.loaded["app"] = app

return app
