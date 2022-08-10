local http = require "luci.http"

local function dispatch(self)
    
    http.status(201, "OK")
    http.prepare_content("application/json")
    http.write('{"message":"ey"}')
    return
end

return {
    dispatch = dispatch
}