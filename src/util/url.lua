local UrlUtil = {}

function UrlUtil.check_url(url)
    return string.match(url, '[a-z]*://[^ >,;]*')
end

return UrlUtil