local shell = require("util.shell")
local file = require("util.file")
local LuciService = {}

LuciService.enable = function()
    shell.execute {"captivefire", "enable_luci"}
    return "Luci had been enabled successfully"
end

LuciService.disable = function()
    shell.execute {"captivefire", "disable_luci"}
    return "Luci had been disabled successfully"
end

return LuciService
