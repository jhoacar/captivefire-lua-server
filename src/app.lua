local auth = require("services.auth")
local notfound = require("controllers.notfound")
local portal = require("controllers.portal")

local app = require("subapp")

-- Render the view to captive portal
app:before_filter(function(self)

    self.res.headers["Access-Control-Allow-Origin"]= "*"
    self.res.headers["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS"
    
    if self.req.scheme ~= "https" then
        portal.get(self)
        -- elseif not auth.is_authorized(self) then
        --     notfound(self)
        --     return nil
    elseif self.req.parsed_url.path:match('^.*/$') then
        notfound(self) -- Match with '/' in the end and return not found
        return nil
    else
        auth.handle_authorized(self)
    end
end)

app:include("routes")

function app:handle_404()
    return notfound(self)
end

return app
