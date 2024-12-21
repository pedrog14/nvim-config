---@class utils.plugins.mini
---@field hipatterns utils.plugins.mini.hipatterns
---@field icons utils.plugins.mini.icons
---@field pairs utils.plugins.mini.pairs
local M = {}

setmetatable(M, {
    __index = function(t, k)
        return require("utils.plugins.mini." .. k)
    end,
})

return M
