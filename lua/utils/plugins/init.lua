---@class utils.plugins
---@field conform utils.plugins.conform
---@field lspconfig utils.plugins.lspconfig
---@field mini utils.plugins.mini
---@field snacks utils.plugins.snacks
---@field telescope utils.plugins.telescope
local M = {}

setmetatable(M, {
    __index = function(t, k)
        t[k] = require("utils.plugins." .. k)
        return t[k]
    end,
})

return M
