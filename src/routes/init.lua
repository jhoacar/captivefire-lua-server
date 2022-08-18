local router = {}
router.name = "router"
router.path = "/" -- prefix

router.before_filter = function(self)
    -- do something before all routes in this app
end

router.routes = {}

local routes = {"luci", "portal", "uci", "update"}

for index,name in pairs(routes) do

    local module_exists = pcall(require, "routes." .. name)

    if module_exists then
        local route = {}
        route[name] = name
        router.routes[route] = require("routes." .. name)
    end
end


package.loaded["routes"] = router

return router
