return {
    "Bekaboo/dropbar.nvim",
    dependencies = "nvim-mini/mini.icons",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = function()
        local symbols = {
            BlockMappingPair = " ",
            BreakStatement = " ",
            Call = " ",
            CaseStatement = " ",
            ContinueStatement = " ",
            Copilot = " ",
            Declaration = " ",
            Delete = " ",
            DoStatement = " ",
            Element = " ",
            ForStatement = " ",
            GotoStatement = " ",
            Identifier = " ",
            IfStatement = " ",
            List = " ",
            Log = " ",
            Lsp = " ",
            Macro = " ",
            Pair = " ",
            Regex = " ",
            Repeat = " ",
            Return = " ",
            Rule = " ",
            RuleSet = " ",
            Scope = " ",
            Section = " ",
            Specifier = " ",
            Statement = " ",
            SwitchStatement = " ",
            Table = " ",
            Terminal = " ",
            Type = " ",
            WhileStatement = " ",

            MarkdownH1 = "󰉫 ",
            MarkdownH2 = "󰉬 ",
            MarkdownH3 = "󰉭 ",
            MarkdownH4 = "󰉮 ",
            MarkdownH5 = "󰉯 ",
            MarkdownH6 = "󰉰 ",
        }

        local symbol_kind = vim.lsp.protocol.SymbolKind
        for _, kind in ipairs(symbol_kind) do
            local icon = MiniIcons.get("lsp", kind --[[@as string]])
            symbols[kind] = icon .. " "
        end

        ---@module "dropbar"
        ---@type dropbar_configs_t
        return {
            icons = {
                kinds = {
                    dir_icon = "",
                    file_icon = function(path)
                        local icon, hl = MiniIcons.get("file", path)
                        return icon .. " ", hl
                    end,
                    symbols = symbols,
                },
                ui = { bar = { separator = "  " }, menu = { indicator = " " } },
            },
        }
    end,
}
