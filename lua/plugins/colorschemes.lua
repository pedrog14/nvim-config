return {
    {
        "pedrog14/gruvbox.nvim",
        branch = "testing",
        lazy = false,
        priority = 1000,
        opts = function()
            local c = require("gruvbox").palette
            return {
                overrides = {
                    -- Base highlights
                    GruvboxRedSign = { link = "GruvboxRed" },
                    GruvboxYellowSign = { link = "GruvboxYellow" },
                    GruvboxBlueSign = { link = "GruvboxBlue" },
                    GruvboxAquaSign = { link = "GruvboxAqua" },
                    GruvboxGreenSign = { link = "GruvboxGreen" },

                    CursorLineNr = { bg = c.dark0, fg = c.bright_yellow, bold = true },

                    NormalFloat = { bg = c.dark0, fg = c.light1 },
                    FloatBorder = { bg = c.dark0, fg = c.dark3 },

                    SignColumn = { link = "Normal" },

                    -- Plugin highlights
                    BufferLineOffsetTitle = { bg = c.dark0, fg = c.bright_blue, bold = true },
                    BufferLineIndicatorSelected = { bg = c.dark0, fg = c.bright_blue },

                    LazyNormal = { bg = c.dark1, fg = c.light1 },
                    LazyButton = { bg = c.dark2 },

                    MasonNormal = { bg = c.dark1, fg = c.light1 },

                    SnacksDashboardHeader = { fg = c.bright_blue },
                    SnacksDashboardIcon = { fg = c.light4 },
                    SnacksDashboardDesc = { fg = c.light4 },
                    SnacksDashboardKey = { fg = c.bright_blue },
                    SnacksDashboardFooter = { fg = c.bright_orange },

                    TelescopeTitle = { link = "FloatTitle" },
                    TelescopePromptBorder = { fg = c.dark3 },
                    TelescopePreviewBorder = { fg = c.dark3 },
                    TelescopeResultsBorder = { fg = c.dark3 },

                    WindowPickerStatusLine = {
                        bg = c.dark1,
                        fg = c.light1,
                        bold = true,
                    },
                    WindowPickerStatusLineNC = {
                        bg = c.dark1,
                        fg = c.light1,
                        bold = true,
                    },
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
