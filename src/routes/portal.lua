local url = require("captivefire.util.url")

return {
    before = function(self)
        -- do something before this route
    end,
    GET = require("captivefire.controllers.notfound"),
    POST = function(self)

        local request_url = self.req.params_post.url

        if not request_url then
            return {
                json = {
                    error = "url is missed"
                },
                status = 400
            }
        end
        if not url.check_url(request_url) then
            return {
                json = {
                    error = "url is incorrect"
                },
                status = 400
            }
        end

        local handler = io.popen("echo '" .. request_url .. "'> " .. env.PATH_URL_FILE)
        handler:close()

        return {
            json = {
                success = "url updated"
            }
        }
    end
}
