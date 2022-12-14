local update = require("services.update")
local UpdateController = {}

UpdateController.get = require("controllers.notfound")

UpdateController.post = function(self)

    local saved = update.save_content_file(self)
    
    return {
        json = {
            message = saved and "saved" or "not saved",
            updated = saved
        }
    }

end

return UpdateController
