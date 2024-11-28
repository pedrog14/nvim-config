---@class utils.plugins.mini
---@field hipatterns utils.plugins.mini.hipatterns
---@field pairs utils.plugins.mini.pairs
local M = {}

setmetatable(M, {
    __index = function(t, k)
        ---@diagnostic disable-next-line: no-unknown
        t[k] = require("utils.plugins.mini." .. k)
        return t[k]
    end,
})

return M
