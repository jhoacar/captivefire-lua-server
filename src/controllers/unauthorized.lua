return function(self)
    self:write({
        json = {
            error = "You don't have access"
        },
        status = 401
    })
    return {
        json = {
            error = "You don't have access"
        },
        status = 401
    }
end
