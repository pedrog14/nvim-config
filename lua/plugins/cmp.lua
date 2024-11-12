return {
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        main = "utils.plugins.cmp",
        ---@param opts { global: cmp.ConfigSchema, cmdline: cmp.ConfigSchema, search: cmp.ConfigSchema }
        opts = function(_, opts)
            local defaults = require("cmp.config.default")()

            local cmp = require("cmp")
            local snippet = vim.snippet

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

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
                        elseif has_words_before() then
                            cmp.complete()
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
