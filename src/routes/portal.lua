return {
    before = function(self)
        -- do something before this route
    end,
    GET = require("captivefire.controllers.notfound"),
    POST = function(self)
        return {
            json = self.req
        }
    end
}
