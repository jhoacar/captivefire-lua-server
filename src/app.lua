local lapis = require "lapis"
local app = lapis.Application()

app:match("/*", function(self)

    return {
        json = self.req.params_post
    }
end)

function app:handle_error(err, trace)
    self.status = 404
    self.err = err
    self.trace = trace
    return {
        status = self.status,
        layout = false,
        render = self.app.error_page
    }
end

return app
