return {
    "Saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
        keymap = { preset = "default" },
        appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        },
        completion = {
            menu = {
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
                },
            },
        },
    },
}
