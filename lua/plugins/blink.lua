return {
    "Saghen/blink.cmp",
    dependencies = { "nvim-mini/mini.icons", "nvim-mini/mini.snippets" },
    version = "*",
    events = { "InsertEnter", "CmdlineEnter" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
            list = { selection = { preselect = false } },
            menu = {
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind", gap = 1 },
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                return kind_icon
                            end,
                        },
                    },
                },
            },
        },
        keymap = {
            preset = "default",
            ["<c-n>"] = { "select_next", "show", "fallback_to_mappings" },
        },
        snippets = { preset = "mini_snippets" },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        cmdline = {
            keymap = {
                preset = "cmdline",
                ["<c-n>"] = { "select_next", "show", "fallback" },
                ["<c-p>"] = { "select_prev", "fallback" },

                ["<tab>"] = { "select_next", "show" },
                ["<s-tab>"] = { "select_prev", "show" },
            },
            completion = {
                list = { selection = { preselect = false } },
            },
        },
    },
}
