return {
    {
        "hrsh7th/nvim-cmp",
        enabled = vim.fn.has("nvim-0.11.0") ~= 1,
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
                    ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-f>"] = cmp.mapping.scroll_docs(4),
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
        enabled = vim.fn.has("nvim-0.11.0") ~= 1,
        lazy = true,
    },

    {
        "garymjr/nvim-snippets",
        enabled = vim.fn.has("nvim-0.11.0") ~= 1,
        dependencies = "rafamadriz/friendly-snippets",
        event = "InsertEnter",
        opts = { friendly_snippets = true },
    },

    {
        "hrsh7th/cmp-buffer",
        enabled = vim.fn.has("nvim-0.11.0") ~= 1,
        event = { "InsertEnter", "CmdlineEnter" },
    },

    {
        "hrsh7th/cmp-path",
        enabled = vim.fn.has("nvim-0.11.0") ~= 1,
        event = { "InsertEnter", "CmdlineEnter" },
    },

    {
        "hrsh7th/cmp-cmdline",
        enabled = vim.fn.has("nvim-0.11.0") ~= 1,
        event = "CmdlineEnter",
    },
}
