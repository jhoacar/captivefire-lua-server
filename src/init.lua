local http = require "luci.http"

local function dispatch(self)

    http.status(201, "OK")
    http.prepare_content("application/json")
    http.write('{"message":"ey"}')
    return
end

local function run()
    local lapis = require "lapis"
    require "captivefire.uhttpd.nginxadapter"
    local app = lapis.Application()

    app:match("/", function(self)
        return "Hello world!"
    end)

    lapis.serve(app)
end

return {
    dispatch = dispatch,
    run = run
}
