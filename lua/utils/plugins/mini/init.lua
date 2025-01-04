---@class utils.plugins.mini
---@field hipatterns utils.plugins.mini.hipatterns
---@field pairs utils.plugins.mini.pairs
local M = {}

setmetatable(M, {
    __index = function(_, k)
        return require("utils.plugins.mini." .. k)
    end,
})

return M
