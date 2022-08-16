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

function _M.get_file_contents(file_name)
    local handler = io.popen("cat " .. file_name)
    local content = handler:read("*all")
    handler:close()
    return content
end

function _M.save_file_contents(content,file_name)
    local handler = io.popen("echo '" .. content .. "'> " .. file_name)
    handler:close()
end

package.loaded["util.file"] = _M

return _M