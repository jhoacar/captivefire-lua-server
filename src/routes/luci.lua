return {
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