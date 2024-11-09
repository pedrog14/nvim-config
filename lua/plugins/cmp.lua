return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = "onsails/lspkind.nvim",
        lazy = true,
        main = "utils.plugins.cmp",
        ---@param opts cmp.Opts
        opts = function(_, opts)
            local defaults = require("cmp.config.default")()

            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local snippet = vim.snippet

            opts.global = {
                sources = cmp.config.sources(
                    { { name = "nvim_lsp" }, { name = "snippets" }, { name = "path" } },
                    { { name = "buffer" } }
                ),
                mapping = {
                    ["<tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif snippet.active({ direction = 1 }) then
                            snippet.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<s-tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif snippet.active({ direction = -1 }) then
                            snippet.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<cr>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = false }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    }),
                    ["<c-e>"] = cmp.mapping.abort(),
                    ["<c-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-d>"] = cmp.mapping.scroll_docs(4),
                },
                snippet = {
                    expand = function(args)
                        return require("utils.plugins.cmp").expand(args.body)
                    end,
                },
                formatting = {
                    format = lspkind.cmp_format(),
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
