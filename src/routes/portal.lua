local url = require("util.url")
local file = require("util.file")

local _M = {
    before = function(self)
        -- do something before this route
    end,
    GET = require("controllers.notfound"),
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

        file.save_file_contents(request_url, env.PATH_URL_FILE)

        return {
            json = {
                success = "url updated"
            }
        }
    end
}

package.loaded["routes.portal"]  = _M

return _M