---@class utils.icons
local M = {}

M.diagnostics = {
    error = "",
    warn = "",
    info = "",
    hint = "",
}

M.mini = function(category)
    local icons = {}
    for _, key in ipairs(require("mini.icons").list(category)) do
        icons[key], _, _ = require("mini.icons").get(category, key)
    end
    return icons
end

return M
