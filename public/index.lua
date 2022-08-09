local pr = require "luci.http"
-- since openwrt 19 try this
-- local pr = require "luci.http"


function handle_request(env)

    local handler = require "captivefir.index"
    handler:handle_response(env)
end
