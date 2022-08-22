local NotFoundController = function(self)
    self:write({
        json = {
            error = "Not found",
        },
        status = 404
    })
    return {
        json = {
            error = "Not found"
        },
        status = 404
    }
end

return NotFoundController
