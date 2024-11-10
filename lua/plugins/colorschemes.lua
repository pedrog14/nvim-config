return {
    {
        "pedrog14/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = function(_, opts)
            local c = require("gruvbox").palette
            opts.overrides = {
                -- Base highlights
                GruvboxRedSign = { link = "GruvboxRed" },
                GruvboxYellowSign = { link = "GruvboxYellow" },
                GruvboxBlueSign = { link = "GruvboxBlue" },
                GruvboxAquaSign = { link = "GruvboxAqua" },
                GruvboxGreenSign = { link = "GruvboxGreen" },

                CursorLineNr = { bg = "NONE", fg = c.bright_yellow, bold = true },

                NormalFloat = { bg = c.dark0, fg = c.light1 },
                FloatBorder = { bg = c.dark0, fg = c.dark3 },

                SignColumn = { bg = "NONE" },

                -- Plugin highlights
                BufferLineOffsetTitle = { link = "GruvboxBlueBold" },
                BufferLineIndicatorSelected = { bg = "NONE", fg = c.bright_blue },

                DashboardHeader = { fg = c.bright_blue },
                DashboardCenter = { fg = c.light4 },
                DashboardShortCut = { fg = c.bright_blue },
                DashboardFooter = { fg = c.bright_orange },

                LazyNormal = { bg = c.dark1, fg = c.light1 },
                LazyButton = { bg = c.dark2 },

                MasonNormal = { bg = c.dark1, fg = c.light1 },

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
