---@class utils
---@field completion utils.completion
---@field icons utils.icons
---@field plugins utils.plugins
local M = {}

setmetatable(M, {
    __index = function(t, k)
        ---@diagnostic disable-next-line: no-unknown
        t[k] = require("utils." .. k)
        return t[k]
    end,
})

return M