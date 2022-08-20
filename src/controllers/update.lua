local update = require("services.update")
local UpdateController = {}

UpdateController.get = require("controllers.notfound")

UpdateController.post = function(self)

    local content = update.save_content_file(self)
    
    return {
        json = {
            message = content or "not updated"
        }
    }

end

package.loaded["controllers.update"] = UpdateController

return UpdateController
