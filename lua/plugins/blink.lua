return {
    "Saghen/blink.cmp",
    dependencies = "echasnovski/mini.icons",
    version = "*",
    opts = function()
        local kind = vim.lsp.protocol.CompletionItemKind
        local kind_icons = {}

        for _, symbol in ipairs(kind) do
            kind_icons[symbol] = MiniIcons.get("lsp", symbol:lower())
        end

        return {
            keymap = { preset = "default", ["<c-n>"] = { "select_next", "show" } },
            appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono", kind_icons = kind_icons },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "lazydev" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
            completion = {
                documentation = { auto_show = true },
                list = { selection = "auto_insert" },
                menu = {
                    draw = {
                        columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
                    },
                },
            },
        }
    end,
}
