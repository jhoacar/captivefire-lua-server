local _M = {
    before = function(self)

    end,
    GET = function(self)
        local luci_url = self.req.parsed_url.scheme .. "://" .. self.req.parsed_url.host .. "/cgi-bin/luci"
        return {
            render = false,
            headers = {
                ["Location"] = luci_url
            },
            status = 302
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

