local _M = {
    before = function(self)
        -- do something before this route
    end,
    GET = function(self)

        return {
            json = "Estoy en luci"
        }
    end,
    POST = function(self)
        return {
            render = true
        }
    end
}


package.loaded["routes.luci"] = _M

return _M

