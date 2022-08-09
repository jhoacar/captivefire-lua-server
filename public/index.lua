local pr = require "luci.http"
-- since openwrt 19 try this
-- local pr = require "luci.http"

function handle_request(env)

    local handler = require "src.index"
    uhttpd.send("Status: 200 OK\r\n")
    uhttpd.send("Content-Type: text/html\r\n\r\n")
    local message = ""
    uhttpd.send("<ul>")
    for key, value in pairs(env) do
        uhttpd.send("<li><strong>" .. key .. " : </strong>")
        if type(value) ~= "table" then
            uhttpd.send("<span>" .. value .. "</span>")
        else
            uhttpd.send("<ul>")
            for key2, value2 in pairs(value) do
                uhttpd.send("<li><strong>" .. key2 .. " : </strong>")
                uhttpd.send("<span>" .. value2 .. "</span>")
            end
            uhttpd.send("</ul>")
        end
        uhttpd.send("</li>")
    end
    uhttpd.send("</ul>")

end
