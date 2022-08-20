local url = require("util.url")
local file = require("util.file")
local portal = require("services.portal")
local portal_page = [[
<head>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Refresh" content="0; URL={{ url }}">
<title>Captivefire - Portal</title>
<style type="text/css">body { background: white;font-family: arial, helvetica, sans-serif; } a { color: black;} @media (prefers-color-scheme: dark) { body {background: black;} a {color: white;}}</style>
</head>
<a href="{{ url }}">Captivefire - Splash Page</a>
]]

local PortalController = {}

function PortalController.get(self)
    local url = portal.get_portal_url()
    self.res.headers["Content-Type"] = "text/html"
    local page = portal_page:gsub("{{ url }}", url)
    self:write(page)
    return {
        render = false
    };
end

function PortalController.post(self)

    local request_url = self.req.params_post.url

    if not request_url then
        return {
            json = {
                error = "url is missed"
            },
            status = 400
        }
    end
    if not url.check_url(request_url) then
        return {
            json = {
                error = "url is incorrect"
            },
            status = 400
        }
    end

    file.save_file_contents(request_url, env.PATH_URL_FILE)

    return {
        json = {
            success = "url updated"
        }
    }
end

package.loaded["controllers.portal"] = PortalController

return PortalController
