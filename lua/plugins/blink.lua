return {
    "Saghen/blink.cmp",
    dependencies = { "echasnovski/mini.icons", "echasnovski/mini.snippets" },
    version = "*",
    events = { "InsertEnter", "CmdlineEnter" },
    opts_extend = { "sources.default" },
    opts = function()
        local kind_icons = {}
        for _, value in ipairs(vim.lsp.protocol.CompletionItemKind) do
            kind_icons[value] = MiniIcons.get("lsp", value:lower()) --[[@diagnostic disable-line: undefined-field]]
        end

        return { --[[@type blink.cmp.Config]]
            snippets = { preset = "mini_snippets" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            cmdline = {
                keymap = {
                    ["<tab>"] = { "select_next", "show_and_insert" },
                    ["<s-tab>"] = { "select_prev", "show_and_insert" },
                },
            },
            keymap = {
                preset = "default",
                ["<c-n>"] = { "select_next", "show", "fallback" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
                kind_icons = kind_icons,
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
}
