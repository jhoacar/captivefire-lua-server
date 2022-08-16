local _M = {
    before = function(self)
        -- do something before this route
    end,
    GET = function(self)

        return {
            json = "Estoy en uci"
        }
    end,
    POST = function(self)
        return {
            render = true
        }
    end
}

package.loaded["routes.uci"] = _M

return _M