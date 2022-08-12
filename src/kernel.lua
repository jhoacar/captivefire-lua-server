local function run(vars)

    -- Using this global variable is loaded ngx variable environment
    env = vars
    env.PATH_URL_FILE = '/app/url.txt'
    env.PATH_SERVICES = '/app/services'
    env.CAPTIVEFIRE_ACCESS = 'http://host.docker.internal:4000'

    json_encode = luci.util.serialize_json
    json_decode = require("cjson").decode

    local lapis = require("lapis")

    -- The adapter must be then the require lapis
    require("nginx.uhttpd.adapter")

    lapis.serve(require("captivefire.app"))
end

return {
    run = run
}
