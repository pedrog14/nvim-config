return {
    {
        "pedrog14/gruvbox.nvim",
        branch = "refactoring",
        lazy = false,
        priority = 1000,
        opts = function()
            local colors = require("gruvbox.colors").palette
            ---@type GruvboxConfig
            return {
                group_override = {
                    -- Base highlights
                    DiagnosticSignError = { bg = colors.none },
                    DiagnosticSignWarn = { bg = colors.none },
                    DiagnosticSignHint = { bg = colors.none },
                    DiagnosticSignInfo = { bg = colors.none },
                    DiagnosticSignOk = { bg = colors.none },

                    CursorLineNr = { bg = colors.none, bold = true },

                    FloatTitle = { bg = colors.none },
                    NormalFloat = { bg = colors.none },
                    FloatBorder = { bg = colors.none },

                    SignColumn = { bg = colors.none },

                    -- Plugin highlights
                    BufferLineOffsetTitle = {
                        fg = colors.bright_blue,
                        bg = colors.dark0,
                        bold = true,
                    },
                    BufferLineIndicatorSelected = {
                        fg = colors.bright_blue,
                        bg = colors.dark0,
                    },

                    LazyNormal = { fg = colors.light1, bg = colors.dark1 },
                    LazyButton = { bg = colors.dark2 },

                    MasonNormal = { fg = colors.light1, bg = colors.dark1 },

                    SnacksDashboardHeader = { fg = colors.bright_blue },
                    SnacksDashboardIcon = { fg = colors.light4 },
                    SnacksDashboardDesc = { fg = colors.light4 },
                    SnacksDashboardKey = { fg = colors.bright_blue },
                    SnacksDashboardFooter = { fg = colors.bright_orange },

                    SnacksInputTitle = { fg = colors.bright_green, bold = true },
                    SnacksInputBorder = { fg = colors.bright_blue },
                    SnacksInputIcon = { fg = colors.bright_red },

                    TelescopeTitle = { fg = colors.bright_blue },
                    TelescopePromptBorder = { fg = colors.bright_blue },
                    TelescopePreviewBorder = { fg = colors.dark3 },
                    TelescopeResultsBorder = { fg = colors.dark3 },
                },
            }
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
}
