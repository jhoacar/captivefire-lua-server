local function run()
    local lapis = require "lapis"
    require "captivefire.uhttpd.nginxadapter"
    local app = require "captivefire.app"
    lapis.serve(app)
end

return {
    run = run
}
