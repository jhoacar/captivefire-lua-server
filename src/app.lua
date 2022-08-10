local lapis = require "lapis"
local app = lapis.Application()

app.layout = require("captivefire.views.layout")

app:match("/", function(self)
    local message = "<ul>"
    for key, value in pairs(env) do
        message = message .. "<li><strong>" .. key .. " :  </strong>"
        if type(value) == "string" or type(value) == "number" then
            message = message .. "<span>" .. value .. "</span>"
        elseif type(value) == "table" then
            message = message .. "<ul>"
            for key2, value2 in pairs(value) do
                message = message .. "<li><strong>" .. key2 .. " : </strong>"
                if type(value) == "string" or type(value) == "number" then
                    message = message .. "<span>" .. value2 .. "</span>"
                end
            end
            message = message .. "</ul>"
        end
        message = message .. "</li>"
    end
    message = message .. "</ul>"

    return message
end)

function app:handle_error(err, trace)
    self.status = 404
    self.err = err
    self.trace = trace
    return {
        status = 500,
        layout = false,
        render = self.app.error_page
    }
end

return app
