-- local lapis = require("lapis")
-- local request = require("luahttp")
-- local app = lapis.Application()
-- app:enable("etlua")

-- app:get("index", "/", function(self)
--     -- renders views/index.etlua
--     return {
--         render = true
--     }
-- end)

-- app:get("/user/:name", function(self)
--     return "Welcome to " .. self.params.name .. "'s profile"
-- end)

-- app:get("/test.json", function(self)
--     return {
--         json = {
--             status = "ok"
--         }
--     }
-- end)

local function dispatch(self)
    

    return "asds"
    -- local messMostrandoage = ""
    -- uhttpd.send("<ul>")
    -- for key, value in pairs(env) do
    --     uhttpd.send("<li><strong>" .. key .. " : </strong>")
    --     if type(value) == "string" or type(value) == "string"  then
    --         uhttpd.send("<span>" .. value .. "</span>")
    --     elseif type(value) == "table" then
    --         uhttpd.send("<ul>")
    --         for key2, value2 in pairs(value) do
    --             uhttpd.send("<li><strong>" .. key2 .. " : </strong>")
    --             uhttpd.send("<span>" .. value2 .. "</span>")
    --         end
    --         uhttpd.send("</ul>")
    --     end
    --     uhttpd.send("</li>")
    -- end
    -- uhttpd.send("</ul>")
end

-- return {
--     dispatch = dispatch
-- }