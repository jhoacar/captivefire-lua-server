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

local _M = function(self)
    local url = portal.get_portal_url()
    local page = portal_page:gsub("{{ url }}", url)
    self:write(page)
    return page;
end

package.loaded["controllers.portal"] = _M

return _M
