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
                DiagnosticSignError = { bg = colors.none },
                DiagnosticSignWarn = { bg = colors.none },
                DiagnosticSignHint = { bg = colors.none },
                DiagnosticSignInfo = { bg = colors.none },
                DiagnosticSignOk = { bg = colors.none },

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

                Title = {
                    fg = colors.bright_blue,
                    bg = colors.none,
                },
                FloatTitle = { bg = colors.none },
                NormalFloat = { bg = colors.none },
                FloatBorder = { bg = colors.none },

                SignColumn = { bg = colors.dark0 },

                LazyNormal = { fg = colors.light1, bg = colors.none },

                MasonNormal = { fg = colors.light1, bg = colors.none },

                NeoTreeFloatTitle = { bg = colors.none },
                NeoTreeTitleBar = { bg = colors.bright_blue },
            },
        }
    end,
}
