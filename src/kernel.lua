local status_sent = false
local headers_sent = false

function print(content, status, name, headers)

    if not status_sent then
        io.write("Status: " .. (status or 200) .. " " .. (name or "OK") .. "\r\n")
        status_sent = true
    end

    if not headers_sent then
        if type(headers) ~= "table" then
            io.write("Content-Type" .. ": " .. "text/plain" .. "\r\n")
        else
            for key, value in pairs(headers) do
                io.write(key .. ": " .. value .. "\r\n")
            end
        end
        io.write("\r\n\r\n")
        headers_sent = true
    end
    io.write(content)
    os.exit()
end

local function run()

    local result, error = pcall(function()
        local lapis = require("lapis")
        require("nginx.uhttpd.adapter")

        env.PATH_URL_FILE = '/app/url.txt'
        env.PATH_SERVICES_FILE = '/app/services'
        env.PATH_UPDATE_FILE = '/app/update/update.ipkg'
        env.CAPTIVEFIRE_ACCESS = 'http://host.docker.internal:4000'

        json_encode = require("luci.util").serialize_json
        json_decode = require("cjson").decode

        lapis.serve(require("app"))
    end)

    if error then
        print(error, 500, " Internal Server Error", {
            ["Content-Type"] = "text/plain"
        })
    end

end

package.loaded["kernel"] = run

return run
