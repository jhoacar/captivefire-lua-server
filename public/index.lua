#!/usr/bin/lua

require "luci.http"

function handle_request(env)
    package.path = "/app/build/?.luac;" .. package.path
    require("captivefire")
    require('kernel')(env)
end
