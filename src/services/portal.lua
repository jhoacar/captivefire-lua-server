local file = require("util.file")
local _M = {}

function _M.get_portal_url()
    local url = file.get_file_contents(env.PATH_URL_FILE)
    return url and #url > 0 and url or "https://www.captivefire.net"
end

package.loaded["services.portal"] =  _M

return _M