package.path = "/app/lua_modules/?.lua;/app/src/?.lua;/app/src/?/init.lua;" .. package.path
local openssl = require("openssl")
for k, v in pairs(openssl) do
    package.loaded["openssl." .. k] = openssl[k]
end

require('kernel')()
