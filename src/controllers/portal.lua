local services = require("captivefire.services")

return function(self)
    self.url = services.portal.get_portal_url()
    self.layout = "captivefire.view.portal"
    self:write({
        render = "portal"
    })
    return {
        render = "portal"
    }
end
