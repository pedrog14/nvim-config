return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "onsails/lspkind.nvim",
            "lukas-reineke/cmp-under-comparator",
            "windwp/nvim-autopairs",
        },
        lazy = true,
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local M = {}

            M.config = {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<s-tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<cr>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({
                                    behavior = cmp.ConfirmBehavior.Replace,
                                    select = false,
                                })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = false }),
                        c = cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = false,
                        }),
                    }),
                    ["<c-e>"] = cmp.mapping.abort(),
                    ["<c-k>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-j>"] = cmp.mapping.scroll_docs(4),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                formatting = {
                    format = require("lspkind").cmp_format(),
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        require("cmp-under-comparator").under,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
            }

            M.config_cmd = function()
                return ":",
                    {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = cmp.config.sources({
                            { name = "path" },
                        }, {
                            {
                                name = "cmdline",
                                option = {
                                    ignore_cmds = { "Man", "!" },
                                },
                            },
                        }),
                        matching = {
                            disallow_symbol_nonprefix_matching = false,
                        },
                    }
            end

            M.config_search = function()
                return { "/", "?" }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = "buffer" },
                    },
                }
            end

            return M
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.setup(opts.config)
            cmp.setup.cmdline(opts.config_cmd())
            cmp.setup.cmdline(opts.config_search())

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        lazy = true,
    },

    {
        "saadparwaiz1/cmp_luasnip",
        dependencies = "L3MON4D3/LuaSnip",
        event = "InsertEnter",
    },

    {
        "hrsh7th/cmp-buffer",
        event = "InsertEnter",
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
