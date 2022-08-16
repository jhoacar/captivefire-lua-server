local _M = {}

function _M.check_url(url)
    return string.match(url, '[a-z]*://[^ >,;]*')
end

package.loaded["util.url"] = _M

return _M