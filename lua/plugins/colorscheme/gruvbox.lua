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
                -- Base highlights
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

                FloatTitle = { bg = colors.none },
                NormalFloat = { bg = colors.none },
                FloatBorder = { bg = colors.none },

                SignColumn = { bg = colors.dark0 },

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

                LazyNormal = { fg = colors.light1, bg = colors.none },
                -- LazyButton = { bg = colors.dark2 },

                MasonNormal = { fg = colors.light1, bg = colors.none },

                -- Don't understand why these doesn't work
                MiniSnippetsCurrent = {
                    sp = colors.none,
                    underdouble = false,
                },
                MiniSnippetsCurrentReplace = {
                    sp = colors.none,
                    underdouble = false,
                },
                MiniSnippetsFinal = {
                    sp = colors.none,
                    underdouble = false,
                },
                MiniSnippetsUnvisited = {
                    sp = colors.none,
                    underdouble = false,
                },
                MiniSnippetsVisited = {
                    sp = colors.none,
                    underdouble = false,
                },

                NeoTreeFloatTitle = {
                    fg = colors.bright_blue,
                    bg = colors.none,
                    bold = false,
                },
                NeoTreeFloatBorder = { fg = colors.bright_blue },
                NeoTreeTitleBar = { bg = colors.bright_blue },

                NoiceCmdlineIcon = { fg = colors.bright_red },

                SnacksDashboardHeader = { fg = colors.bright_blue },
                SnacksDashboardIcon = { fg = colors.light4 },
                SnacksDashboardDesc = { fg = colors.light4 },
                SnacksDashboardKey = { fg = colors.bright_blue },
                SnacksDashboardFooter = { fg = colors.bright_orange },

                SnacksInputTitle = { fg = colors.bright_blue },
                SnacksInputBorder = { fg = colors.bright_blue },
                SnacksInputIcon = { fg = colors.bright_red },

                SnacksPicker = { fg = colors.light1, bg = colors.none },
                SnacksPickerTitle = { fg = colors.bright_blue },
                SnacksPickerBorder = { fg = colors.bright_blue },
                SnacksPickerPrompt = { fg = colors.bright_red },
                SnacksPickerDir = { fg = colors.gray },

                TelescopeTitle = { fg = colors.bright_blue },
                TelescopeBorder = { fg = colors.bright_blue },

                TroubleIconDirectory = { fg = colors.bright_blue },
            },
        }
    end,
}
