local FileUtil = {}

function FileUtil.script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

function FileUtil.scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls "' .. directory .. '"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function FileUtil.get_file_contents(file_name)
    local file = assert(io.open(file_name, "r"))
    local content = file:read("*all")
    file:close()
end

function FileUtil.save_file_contents(content, file_name)
    local file = assert(io.open(file_name, "w"))
    file:write(content)
    file:close()
end

package.loaded["util.file"] = FileUtil

return FileUtil
