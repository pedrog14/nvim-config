---@class utils.plugins.mini
---@field hipatterns utils.plugins.mini.hipatterns
---@field icons utils.plugins.mini.icons
---@field pairs utils.plugins.mini.pairs
local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require("utils.plugins.mini." .. k)
        return t[k]
    end,
})

return M
