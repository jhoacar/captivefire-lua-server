local _M = {}
function _M.map(tbl, fn)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = fn(v)
    end
    return t
end

function _M.filter(t, fn)
    local out = {}
  
    for k, v in pairs(t) do
      if fn(v, k, t) then table.insert(out,v) end
    end
  
    return out
  end

table.map = _M.map
table.filter = _M.filter

return _M
