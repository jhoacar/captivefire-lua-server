local file = require("util.file")
local PortalService = {}

function PortalService.get_portal_url()
    local status, url = pcall(file.get_file_contents, env.PATH_URL_FILE)
    return status and url or "https://www.captivefire.net"
end

package.loaded["services.portal"] = PortalService

return PortalService
