#!/usr/bin/lua

require "luci.http"

function handle_request(env)
    require('captivefire.kernel')(env)
end
