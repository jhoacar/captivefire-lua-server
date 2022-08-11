local function run(vars)
    -- Using this global variable is loaded ngx variable environment
    env = vars

    local lapis = require "lapis"
    require "captivefire.uhttpd.nginx-adapter"

    local app = require "captivefire.app"
    
    lapis.serve(app)
end

return {
    run = run
}
