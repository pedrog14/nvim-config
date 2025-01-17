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

                FloatTitle = {
                    bg = colors.none,
                    fg = colors.bright_blue,
                    bold = false,
                },
                NormalFloat = { bg = colors.none },
                FloatBorder = { bg = colors.none },

                SignColumn = { bg = colors.dark0 },

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
                NeoTreeTitleBar = { bg = colors.bright_blue },

                -- Noice
                NoiceCmdlineIcon = { fg = colors.bright_red },
                NoiceCmdlineIconLua = { fg = colors.bright_blue },

                NoiceCmdlinePopupBorder = { fg = colors.dark3 },

                NoiceCmdlinePopupTitle = { fg = colors.bright_blue },
                NoiceCmdlinePopupTitleLua = { link = "NoiceCmdlinePopupTitle" },
                NoiceCmdlinePopupTitleHelp = { link = "NoiceCmdlinePopupTitle" },
                NoiceCmdlinePopupTitleInput = {
                    link = "NoiceCmdlinePopupTitle",
                },
                NoiceCmdlinePopupTitleFilter = {
                    link = "NoiceCmdlinePopupTitle",
                },
                NoiceCmdlinePopupTitleCmdline = {
                    link = "NoiceCmdlinePopupTitle",
                },
                NoiceCmdlinePopupTitleCalculator = {
                    link = "NoiceCmdlinePopupTitle",
                },

                -- Snacks
                SnacksDashboardHeader = { fg = colors.bright_blue },
                SnacksDashboardIcon = { fg = colors.light4 },
                SnacksDashboardDesc = { fg = colors.light4 },
                SnacksDashboardKey = { fg = colors.bright_blue },
                SnacksDashboardFooter = { fg = colors.bright_orange },

                SnacksInputTitle = { link = "FloatTitle" },
                SnacksInputBorder = { link = "FloatBorder" },
                SnacksInputIcon = { fg = colors.bright_red },

                SnacksPicker = { fg = colors.light1, bg = colors.none },
                SnacksPickerTitle = { link = "FloatTitle" },
                SnacksPickerPrompt = { fg = colors.bright_red },
                SnacksPickerDir = { fg = colors.gray },

                TelescopeTitle = { fg = colors.bright_blue },

                TroubleIconDirectory = { fg = colors.bright_blue },
            },
        }
    end,
}
