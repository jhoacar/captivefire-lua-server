local ArrayUtil = {}

function ArrayUtil.has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function ArrayUtil.map(tbl, fn)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = fn(v)
    end
    return t
end

function ArrayUtil.filter(t, fn)
    local out = {}

    for k, v in pairs(t) do
        if fn(v, k, t) then
            table.insert(out, v)
        end
    end

    return out
end

table.map = ArrayUtil.map
table.filter = ArrayUtil.filter

return ArrayUtil
