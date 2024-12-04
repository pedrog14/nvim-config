return {
    {
        "pedrog14/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = function()
            local c = require("gruvbox").palette
            ---@type GruvboxConfig
            return {
                overrides = {
                    -- Base highlights
                    GruvboxRedSign = { fg = c.bright_red, bg = "NONE" },
                    GruvboxYellowSign = { fg = c.bright_yellow, bg = "NONE" },
                    GruvboxBlueSign = { fg = c.bright_blue, bg = "NONE" },
                    GruvboxAquaSign = { fg = c.bright_aqua, bg = "NONE" },
                    GruvboxGreenSign = { fg = c.bright_green, bg = "NONE" },

                    CursorLineNr = {
                        fg = c.bright_yellow,
                        bg = c.dark0,
                        bold = true,
                    },

                    NormalFloat = { fg = c.light1, bg = c.dark0 },
                    FloatBorder = { fg = c.dark3, bg = c.dark0 },

                    SignColumn = { bg = c.dark0 },

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
