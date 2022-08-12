local function run(vars)

    -- Using this global variable is loaded ngx variable environment
    env = vars

    local lapis = require("lapis")

    -- The adapter must be then the require lapis
    require("nginx.uhttpd.adapter")

    lapis.serve(require("captivefire.app"))
end

return {
    run = run
}
