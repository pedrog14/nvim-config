return {
    "Saghen/blink.cmp",
    dependencies = { "echasnovski/mini.icons", "echasnovski/mini.snippets" },
    build = "cargo build --release",
    events = { "InsertEnter", "CmdlineEnter" },
    opts = function()
        local kind = vim.lsp.protocol.CompletionItemKind
        local kind_icons = {}

        for _, symbol in ipairs(kind) do
            kind_icons[symbol] = MiniIcons.get("lsp", symbol:lower()) ---@diagnostic disable-line: undefined-field
        end

        ---@type blink.cmp.Config
        return {
            keymap = {
                preset = "default",
                ["<c-n>"] = { "select_next", "show" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
                kind_icons = kind_icons,
            },
            snippets = { preset = "mini_snippets" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            completion = {
                documentation = { auto_show = true },
                list = { selection = { preselect = false } },
                menu = {
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 1 },
                        },
                    },
                },
            },
        }
    end,
    opts_extend = { "sources.default" },
}
