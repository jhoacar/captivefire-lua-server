#!/usr/bin/lua

require "luci.http"

function handle_request(env)
    require("captivefire").run(env)
end
