---@class utils
---@field completion utils.completion
---@field icons utils.icons
---@field plugins utils.plugins
local M = {}

setmetatable(M, {
    __index = function(t, k)
        return require("utils." .. k)
    end,
})

return M
