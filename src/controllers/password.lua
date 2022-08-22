local service = require("services.password")
local PasswordController = {}

PasswordController.get = require("controllers.notfound")
PasswordController.post = function(self)

    local password = self.req.params_post.password

    if not password or type(password) ~= "string" then
        return {
            json = {
                error = "password is missed - " .. type(password)
            },
            status = 400
        }
    end

    local message = service.change(password)

    return {
        json = {
            message = message
        }
    }
end

return PasswordController
