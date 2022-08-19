local function fix_dependecies()
    package.path = "/app/lua_modules/?.lua;" .. package.path
    local openssl = require("openssl")
    for k, v in pairs(openssl) do
        package.loaded["openssl." .. k] = openssl[k]
    end
end

fix_dependecies()
