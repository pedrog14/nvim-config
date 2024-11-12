--------------------
-- 󰒓 Neovim utils --
--------------------

local utils = {}

utils.icons = {
    diagnostics = {
        error = " ",
        warn = " ",
        info = " ",
        hint = " ",
    },
    mini = function(category)
        local icons = {}
        for _, key in ipairs(require("mini.icons").list(category)) do
            icons[key], _, _ = require("mini.icons").get(category, key)
        end
        return icons
    end,
}

return utils
