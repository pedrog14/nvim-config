return {
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        main = "utils.plugins.cmp",
        ---@param opts { global: cmp.ConfigSchema, cmdline: cmp.ConfigSchema, search: cmp.ConfigSchema }
        opts = function(_, opts)
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()

            opts.global = {
                sources = cmp.config.sources(
                    { { name = "nvim_lsp" }, { name = "snippets" }, { name = "path" } },
                    { { name = "buffer" } }
                ),
                mapping = cmp.mapping.preset.insert({
                    ["<c-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                }),
                snippet = {
                    expand = function(args)
                        return require("utils.plugins.cmp").expand(args.body)
                    end,
                },
                ---@diagnostic disable-next-line: missing-fields
                formatting = {
                    format = require("utils.plugins.cmp").format_cmp,
                },
                sorting = defaults.sorting,
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
            }
            opts.cmdline = {
                sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
                mapping = cmp.mapping.preset.cmdline(),
                ---@diagnostic disable-next-line: missing-fields
                matching = { disallow_symbol_nonprefix_matching = false },
            }
            opts.search = {
                sources = { { name = "buffer" } },
                mapping = cmp.mapping.preset.cmdline(),
            }
        end,
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        lazy = true,
    },

    {
        "garymjr/nvim-snippets",
        dependencies = "rafamadriz/friendly-snippets",
        event = "InsertEnter",
        opts = { friendly_snippets = true },
    },

    {
        "hrsh7th/cmp-buffer",
        event = { "InsertEnter", "CmdlineEnter" },
    },

    {
        "hrsh7th/cmp-path",
        event = { "InsertEnter", "CmdlineEnter" },
    },

    {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
    },
}
