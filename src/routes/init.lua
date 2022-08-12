local file = require("captivefire.util.file")
local router = {}
router.name = "router"
router.path = "/" -- prefix

router.before_filter = function(self)
    -- do something before all routes in this app
end
local files = file.scandir(file.script_path())

router.routes = {}

for key, value in pairs(files) do

    local file_without_ext = value:match("(.+)%..+$")

    if file_without_ext then
        local module_exists = not file_without_ext:match('^init$') and
                                  pcall(require, "captivefire.routes." .. file_without_ext)

        if module_exists then
            local route = {}
            route[file_without_ext] = file_without_ext
            router.routes[route] = require("captivefire.routes." .. file_without_ext)
        end
    end
end

return router
