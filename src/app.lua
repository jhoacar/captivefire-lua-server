local lapis = require "lapis"
local app = lapis.Application()
app:enable("etlua")

-- app.layout = require("captivefire.views.layout")

app:match("/", function(self)

    local utils = require "luci.util"

    local message = "<ul>"

    for key, value in pairs(env) do
        message = message .. "<li><strong>" .. key .. " :  </strong>"
        if type(value) == "string" or type(value) == "number" then
            message = message .. "<span>" .. value .. "</span>"
        elseif type(value) == "table" then
            message = message .. "<ul>"
            for key2, value2 in pairs(value) do
                message = message .. "<li><strong>" .. key2 .. " : </strong>"
                if type(value2) == "string" or type(value2) == "number" then
                    message = message .. "<span>" .. value2 .. "</span>"
                end
            end
            message = message .. "</ul>"
        end
        message = message .. "</li>"
    end
    local POST = nil
    local POSTLength = tonumber(env.CONTENT_LENGTH) or 0
    if (POSTLength > 0 and POSTLength < 4096) then
        POST = ngx.req.read_body()
    end
    POST = POST or "-"
    message = message .. "<li><strong>POST: </strong>" .. POST .. "</li>"
    message = message .. "<li><strong>PARSED: </strong>" .. utils.serialize_json(ngx.req.get_body_data()) .. "</li>"
    message = message .. "</ul>"
    message = message .. [[
        <form method="POST">
            <input type="text" name="mensaje" value="Hola mundo">
            <input type="text" name="otromensaje" value="Mensaje!!">
            <input type="submit" value="Send">
        </form>
    ]]
    return message
end)

app:match("/animals", function(self)
    self.pets = {"Cat", "Dog", "Bird"}
    return {
        render = "hello"
    }
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
