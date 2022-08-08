local pr = require "luci.http"
-- since openwrt 19 try this
-- local pr = require "luci.http"

function handle_request(env)
    uhttpd.send("Status: 200 OK\r\n")
    uhttpd.send("Content-Type: text/html\r\n\r\n")
    uhttpd.send('<h1>Hello Mundo</h1>')
end