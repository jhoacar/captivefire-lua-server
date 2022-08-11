local services = require("captivefire.services")

return function(self)
    self.url = services.portal.get_portal_url()
    self:write({
        render = "portal"
    })
end
