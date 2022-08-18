#!/usr/bin/lua

function handle_request(env)
    loadfile('/app/build/captivefire.luac')()
    require('kernel')(env)
end
