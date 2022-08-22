local uci = require("services.uci")
local UciController = {}

UciController.get = require("controllers.notfound")

UciController.post = function(self)

    local action = self.req.params_post.action
    local configuration = self.req.params_post.configuration
    local section = self.req.params_post.section
    local option = self.req.params_post.option
    local value = self.req.params_post.value

    local result = uci.execute(action, configuration, section, option, value)
    return {
        json = result
    }
end

return UciController
