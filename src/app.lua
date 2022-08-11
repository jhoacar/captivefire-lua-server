local lapis = require("lapis")
local json_params = require("lapis.application").json_params
local auth = require("captivefire.services").auth
local notfound = require("captivefire.controllers.notfound")
local portal = require("captivefire.controllers.portal")
local routes = require("captivefire.routes")

local app = lapis.Application()

app:enable("etlua")

-- Render the view to captive portal
app:before_filter(function(self)
    if self.req.scheme ~= "https" then
        portal(self)
    elseif not auth.is_authorized(self.req) then
        notfound(self)
    else
        auth.set_headers(self.req)
    end
end)

function app:handle_404()
    return notfound(nil)
end

return app
