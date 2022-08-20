local ShellUtil = {}

function ShellUtil.escape(args)
    local ret = {}
    for _, a in pairs(args) do
        local s = tostring(a)
        if s:match("[^A-Za-z0-9_/:=-]") then
            s = "'" .. s:gsub("'", "'\\''") .. "'"
        end
        table.insert(ret, s)
    end
    return table.concat(ret, " ")
end

function ShellUtil.run(args)
    local h = io.popen(ShellUtil.escape(args))
    local outstr = h:read("*a")
    return h:close(), outstr
end

function ShellUtil.execute(args)
    return os.execute(ShellUtil.escape(args))
end

package.loaded["util.shell"] = ShellUtil

return ShellUtil
