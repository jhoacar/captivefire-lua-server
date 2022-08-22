local shell = require("util.shell")
local PasswordService = {}

PasswordService.change = function(password)
    local command = "echo -e '" .. password .. "\n" .. password .. "' | passwd"
    local handler = io.popen(command)
    local message = handler:read("*all")
    handler:close()
    return message
end

return PasswordService
