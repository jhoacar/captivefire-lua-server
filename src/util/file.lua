local _M = {}

function _M.script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

function _M.scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls "' .. directory .. '"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

return _M
