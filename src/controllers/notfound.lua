local _M = function(self)
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

package.loaded["controllers.notfound"] = _M

return _M
