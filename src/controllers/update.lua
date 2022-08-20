local UpdateController = {}

UpdateController.get = function(self)
    return {
        json = {
            message = "Get Update"
        }
    }
end

UpdateController.post = function(self)
    return {
        json = {
            message = "Post Update"
        }
    }
end

package.loaded["controllers.update"] = UpdateController

return UpdateController
