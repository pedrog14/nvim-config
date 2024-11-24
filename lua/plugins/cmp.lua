return {
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        main = "utils.plugins.cmp",
        opts = function()
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            ---@type { global: cmp.ConfigSchema, cmdline: cmp.ConfigSchema, search: cmp.ConfigSchema }
            return {
                global = {
                    sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "path" } }, { { name = "buffer" } }),
                    mapping = cmp.mapping.preset.insert({
                        ["<tab>"] = cmp.mapping(function(fallback)
                            if vim.snippet.active({ direction = 1 }) then
                                vim.snippet.jump(1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<s-tab>"] = cmp.mapping(function(fallback)
                            if vim.snippet.active({ direction = -1 }) then
                                vim.snippet.jump(-1)
                            else
                                fallback()
                            end
                        end, { "i", "s" }),

                        ["<c-y>"] = cmp.mapping.confirm({ select = true }),
                        ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                        ["<c-f>"] = cmp.mapping.scroll_docs(4),
                    }),
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
                },
                cmdline = {
                    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
                    mapping = cmp.mapping.preset.cmdline(),
                    ---@diagnostic disable-next-line: missing-fields
                    matching = { disallow_symbol_nonprefix_matching = false },
                },
                search = {
                    sources = { { name = "buffer" } },
                    mapping = cmp.mapping.preset.cmdline(),
                },
            }
        end,
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        lazy = true,
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
