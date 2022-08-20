local shell = require("util.shell")
local file = require("util.file")
local LuciService = {}

LuciService.enable = function()
    shell.execute {"uci", "set", "uhttpd.captivefire.no_symlinks=0"}
    shell.execute {"uci", "set", "uhttpd.captivefire.ubus_prefix=/ubus"}
    shell.execute {"uci", "commit"}
    file.save_file_contents("uhttpd", env.PATH_SERVICES)
    return "Luci had been enabled successfully"
end

LuciService.disable = function()
    shell.execute {"uci", "set", "uhttpd.captivefire.no_symlinks=1"}
    shell.execute {"uci", "del", "uhttpd.captivefire.ubus_prefix"}
    shell.execute {"uci", "commit"}
    file.save_file_contents("uhttpd", env.PATH_SERVICES)
    return "Luci had been disabled successfully"
end

package.loaded["services.luci"] = LuciService

return LuciService
