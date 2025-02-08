return {
    -- "pedrog14/gruvbox.nvim",
    dir = "~/Git/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
        local colors = require("gruvbox.colors").palette
        ---@type GruvboxConfig
        return {
            group_override = {
                CursorLineNr = { bg = colors.none, bold = true },
                SignColumn = { bg = colors.dark0 },
            },
        }
    end,
}
