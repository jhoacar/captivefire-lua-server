#!/usr/bin/lua

require "luci.http"

function handle_request(env)
    local kernel = require("captivefire.kernel")
    kernel.run(env)
end
