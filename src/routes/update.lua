local _M = {
    before = function(self)
        -- do something before this route
    end,
    GET = function(self)

        return {
            json = env.HTTP_AUTHORIZATION or "Estoy en update"
        }
    end,
    POST = function(self)
        return {
            json = env.HTTP_AUTHORIZATION or "Estoy en update"
        }
    end
}

package.loaded["routes.update"] = _M

return _M
