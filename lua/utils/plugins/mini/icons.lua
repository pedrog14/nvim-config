---@class utils.plugins.mini.icons
local M = {}

M.get = function(category)
    local icons = {}
    for _, key in ipairs(MiniIcons.list(category)) do
        icons[key], _, _ = MiniIcons.get(category, key)
    end
    return icons
end

return M
