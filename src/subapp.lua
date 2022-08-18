-- https://github.com/VaiN474/lapis-lua-subapps

local lapis = require("lapis")
local json = require("cjson")
local app = lapis.Application()
local respond_to = require("lapis.application").respond_to
local json_params = function(fn)
    return function(self, ...)
        do
            local content_type = self.req.headers["content-type"]
            if content_type then
                if string.find(content_type:lower(), "application/json", nil, true) then
                    ngx.req.read_body()
                    local body = ngx.req.get_body_data()

                    local success, obj_or_err = pcall(function()
                        return json.decode(body)
                    end)
                    if success then
                        self.req.params_post = obj_or_err
                        -- self.__class.support.add_params(self, obj_or_err, "json")
                    end
                end
            end
        end
        return fn(self, ...)
    end
end

function app:include(app_path)
    local subapp = assert(require(app_path))
    if not type(subapp) == "table" then
        error("Unable to include sub-app '" .. app_path .. "', table expected got " .. type(subapp))
    end

    if not subapp.name or not subapp.path then
        error("Sub-app must have a name and path")
    end

    for route, action in pairs(subapp.routes) do
        for k, v in pairs(route) do

            self:match(subapp.name .. "_" .. k, subapp.path .. v, respond_to({
                before = function(self)
                    if subapp.before_filter then
                        subapp.before_filter(self)
                    end
                    if action.before then
                        return action.before(self)
                    end
                end,
                GET = function(self)
                    if action.GET then
                        local result = action.GET(self)
                        if result.render ~= nil then
                            if type(result.render) == "boolean" and result.render == true then
                                result.render = subapp.name .. "." .. k
                            end
                        end
                        if result.layout == nil then
                            if subapp.layout then
                                result.layout = subapp.layout
                            end
                        end
                        return result
                    end
                end,
                POST = json_params(function(self)
                    if action.POST then
                        local result = action.POST(self)
                        if result.render ~= nil then
                            if type(result.render) == "boolean" and result.render == true then
                                result.render = subapp.name .. "." .. k
                            end
                        end
                        if result.layout == nil then
                            if subapp.layout then
                                result.layout = subapp.layout
                            end
                        end
                        return result
                    end
                end)
            }))
        end
    end

end

package.loaded["subapp"] = app

return app
