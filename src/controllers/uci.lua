local UciController = {}

UciController.get = function(self)

    return {
        json = "Estoy en uci"
    }
end

UciController.post = function(self)
    return {
        json = "Post en uci"
    }
end

package.loaded["controllers.uci"] = UciController

return UciController
