return {
    "pedrog14/gruvbox.nvim",
    branch = "refactor",
    lazy = false,
    priority = 1000,
    opts = function()
        local colors = require("gruvbox.colors").palette
        ---@type GruvboxConfig
        return {
            group_override = {
                NormalFloat = { bg = colors.none },
                FloatTitle = { bg = colors.none },
                FloatBorder = { bg = colors.none },

                CursorLineNr = { bg = colors.none, bold = true },

                Error = {
                    fg = colors.bright_red,
                    bg = colors.none,
                    bold = false,
                },
                ErrorMsg = {
                    fg = colors.bright_red,
                    bg = colors.none,
                    bold = false,
                },

                Removed = { fg = colors.bright_red },

                Title = { fg = colors.bright_blue },

                SignColumn = { bg = colors.dark0 },

                MasonNormal = { fg = colors.light1, bg = colors.dark1 },

                SnacksPickerDirectory = { fg = colors.light1, bold = true },
                SnacksPickerGitStatusUntracked = { fg = colors.bright_purple },

                WhichKeyNormal = { bg = colors.none },
                WhichKeyTitle = { bg = colors.none },
                WhichKeyBorder = { bg = colors.none },
            },
        }
    end,
}
