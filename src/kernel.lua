local function run(vars)
    local lapis = require "lapis"
    env = vars
    require "captivefire.uhttpd.nginxadapter"
    local app = require "captivefire.app"
    lapis.serve(app)
end

return {
    run = run
}
