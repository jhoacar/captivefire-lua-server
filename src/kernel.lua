local status_sent = false
local headers_sent = false

local function print(status, name, headers, content)

    if not status_sent then
        io.write("Status: " .. (status or 200) .. " " .. (name or "OK") .. "\r\n")
        status_sent = true
    end

    if not headers_sent then
        for key, value in pairs(headers) do
            io.write(key .. ": " .. value .. "\r\n")
        end
        io.write("\r\n\r\n")
        headers_sent = true
    end
    io.write(content)
end

local function run()

    local result, error = pcall(function()
        local lapis = require("lapis")
        require("nginx.uhttpd.adapter")

        env.PATH_URL_FILE = '/app/url.txt'
        env.PATH_SERVICES = '/app/services'
        env.CAPTIVEFIRE_ACCESS = 'http://host.docker.internal:4000'

        json_encode = require("luci.util").serialize_json
        json_decode = require("cjson").decode

        lapis.serve(require("app"))
    end)

    if error then
        print(500, " Internal Server Error", {
            ["Content-Type"] = "text/plain"
        }, error)
    end

end

package.loaded["kernel"] = run

return run
