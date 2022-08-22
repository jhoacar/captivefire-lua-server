local shell = require("util.shell")
local file = require("util.file")
local array = require("util.array")

local actions = {"export", "import", "changes", "add", "add_list", "del_list", "show", "get", "set", "delete", "rename",
                 "revert", "reorder"}
local forbidden_configuration = {"uhttpd", "dropbear"}

local UciService = {}

local commit = function(configuration)
    local command = "uci commit " .. configuration
    local handler = io.popen(command)
    local result = handler:read("*all")
    handler:close()
    file.save_file_contents(configuration, env.PATH_SERVICES_FILE)
    return {
        command = command,
        result = result
    }
end

local dispatch = function(action, configuration, section, option, value)

    local command = string.format("uci %s %s", action, configuration)

    if #section > 1 then
        command = string.format("%s.%s", command, section)
    end
    if #option > 1 then
        command = string.format("%s.%s", command, option)
    end
    if #value > 1 then
        command = string.format("%s=%s", command, #value)
    end

    local handler = io.popen(command)
    local result = handler:read("*all")
    handler:close()
    return {
        command = command,
        result = result
    }
end

UciService.execute = function(action, configuration, section, option, value)

    if not action or type(action) ~= "string" or #action < 1 then
        return {
            error = "action is required"
        }
    end

    if not configuration or type(configuration) ~= "string" or #configuration < 1 then
        return {
            error = "configuration is required"
        }
    end

    if array.has_value(forbidden_configuration, configuration) then
        return {
            error = "forbidden configuration"
        }
    end

    action = shell.escape {action}
    configuration = shell.escape {configuration}

    section = section and type(section) == "string" and shell.escape {section} or ""
    option = option and type(option) == "string" and shell.escape {option} or ""
    value = value and type(option) == "string" and shell.escape {value} or ""

    if action == "commit" then
        return commit(configuration)
    end

    for index, action_available in ipairs(actions) do
        if action_available == action then
            return dispatch(action, configuration, section, option, value)
        end
    end

    return {
        error = string.format("action %s missed in (%s)", action, table.concat(actions, ", "))
    }
end

return UciService
