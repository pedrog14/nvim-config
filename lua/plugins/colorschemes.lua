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

                    CursorLineNr = {
                        fg = c.bright_yellow,
                        bg = c.dark0,
                        bold = true,
                    },

                    NormalFloat = { fg = c.light1, bg = c.dark0 },
                    FloatBorder = { fg = c.dark3, bg = c.dark0 },

                    SignColumn = { link = "Normal" },

                    -- Plugin highlights
                    BufferLineOffsetTitle = {
                        fg = c.bright_blue,
                        bg = c.dark0,
                        bold = true,
                    },
                    BufferLineIndicatorSelected = {
                        fg = c.bright_blue,
                        bg = c.dark0,
                    },

                    LazyNormal = { fg = c.light1, bg = c.dark1 },
                    LazyButton = { bg = c.dark2 },

                    MasonNormal = { fg = c.light1, bg = c.dark1 },

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
                        fg = c.light1,
                        bg = c.dark1,
                        bold = true,
                    },
                    WindowPickerStatusLineNC = {
                        fg = c.light1,
                        bg = c.dark1,
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
