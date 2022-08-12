local _M = {}

function _M.check_url(url)
    return string.match(url, '[a-z]*://[^ >,;]*')
end

return _M
