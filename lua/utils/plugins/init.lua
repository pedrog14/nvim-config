---@class utils.plugins
---@field lint utils.plugins.lint
---@field lspconfig utils.plugins.lspconfig
---@field mason utils.plugins.mason
---@field mini utils.plugins.mini
---@field snacks utils.plugins.snacks
---@field telescope utils.plugins.telescope
local M = {}

setmetatable(M, {
    __index = function(_, k)
        return require("utils.plugins." .. k)
    end,
})

return M
