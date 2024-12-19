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
                overrides = {
                    -- Base highlights
                    GruvboxRedSign = { fg = colors.bright_red, bg = "NONE" },
                    GruvboxYellowSign = { fg = colors.bright_yellow, bg = "NONE" },
                    GruvboxBlueSign = { fg = colors.bright_blue, bg = "NONE" },
                    GruvboxAquaSign = { fg = colors.bright_aqua, bg = "NONE" },
                    GruvboxGreenSign = { fg = colors.bright_green, bg = "NONE" },

                    CursorLineNr = { fg = colors.bright_yellow, bg = "NONE", bold = true },

                    NormalFloat = { fg = colors.light1, bg = colors.dark0 },
                    FloatBorder = { fg = colors.dark3, bg = colors.dark0 },

                    SignColumn = { bg = "NONE" },

                    -- Plugin highlights
                    BufferLineOffsetTitle = { fg = colors.bright_blue, bg = colors.dark0, bold = true },
                    BufferLineIndicatorSelected = { fg = colors.bright_blue, bg = colors.dark0 },

                    LazyNormal = { fg = colors.light1, bg = colors.dark1 },
                    LazyButton = { bg = colors.dark2 },

                    MasonNormal = { fg = colors.light1, bg = colors.dark1 },

                    MiniFilesTitle = { fg = colors.bright_blue },
                    MiniFilesTitleFocused = { fg = colors.bright_blue, bold = true },
                    MiniFilesDirectory = { fg = colors.bright_blue },

                    SnacksDashboardHeader = { fg = colors.bright_blue },
                    SnacksDashboardIcon = { fg = colors.light4 },
                    SnacksDashboardDesc = { fg = colors.light4 },
                    SnacksDashboardKey = { fg = colors.bright_blue },
                    SnacksDashboardFooter = { fg = colors.bright_orange },

                    SnacksInputTitle = { fg = colors.bright_blue },
                    SnacksInputBorder = { fg = colors.bright_blue },
                    SnacksInputIcon = { fg = colors.bright_red },

                    TelescopeTitle = { fg = colors.bright_blue },
                    TelescopePromptBorder = { fg = colors.bright_blue },
                    TelescopePreviewBorder = { fg = colors.dark3 },
                    TelescopeResultsBorder = { fg = colors.dark3 },

                    WindowPickerStatusLine = { fg = colors.light1, bg = colors.dark1, bold = true },
                    WindowPickerStatusLineNC = { fg = colors.light1, bg = colors.dark1, bold = true },
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
