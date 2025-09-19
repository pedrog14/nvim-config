return {
    {
        "nvim-mini/mini.ai",
        event = { "BufNewFile", "BufReadPre" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({ -- code block
                        a = {
                            "@block.outer",
                            "@conditional.outer",
                            "@loop.outer",
                        },
                        i = {
                            "@block.inner",
                            "@conditional.inner",
                            "@loop.inner",
                        },
                    }),
                    f = ai.gen_spec.treesitter({ -- function
                        a = "@function.outer",
                        i = "@function.inner",
                    }),
                    c = ai.gen_spec.treesitter({ -- class
                        a = "@class.outer",
                        i = "@class.inner",
                    }),
                    t = {
                        "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", -- tags

                        "^<.->().*()</[^/]->$",
                    },
                    d = { "%f[%d]%d+" }, -- digits
                    e = { -- Word with case
                        {
                            "%u[%l%d]+%f[^%l%d]",
                            "%f[%S][%l%d]+%f[^%l%d]",
                            "%f[%P][%l%d]+%f[^%l%d]",
                            "^[%l%d]+%f[^%l%d]",
                        },
                        "^().*()$",
                    },
                    u = ai.gen_spec.function_call(), -- u for "Usage"
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
                },
            }
        end,
    },
    {
        "nvim-mini/mini.icons",
        lazy = true,
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        opts = {},
    },
    {
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        main = "utils.plugins.mini.pairs",
        opts = {
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { "string" },
            skip_unbalanced = true,
            markdown = true,
        },
    },
    {
        "nvim-mini/mini.snippets",
        dependencies = "rafamadriz/friendly-snippets",
        lazy = true,
        opts = function()
            -- Stop all sessions on Normal mode exit
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniSnippetsSessionStart",
                callback = function()
                    vim.api.nvim_create_autocmd("ModeChanged", {
                        pattern = "*:n",
                        once = true,
                        callback = function()
                            while MiniSnippets.session.get() do
                                MiniSnippets.session.stop()
                            end
                        end,
                    })
                end,
            })
            -- Stop session immediately after jumping to final tabstop
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniSnippetsSessionJump",
                callback = function(args)
                    if args.data.tabstop_to == "0" then
                        MiniSnippets.session.stop()
                    end
                end,
            })

            local gen_loader = require("mini.snippets").gen_loader

            return {
                expand = {
                    insert = function(snippet)
                        return MiniSnippets.default_insert(snippet, { empty_tabstop = "", empty_tabstop_final = "" })
                    end,
                },
                mappings = {
                    jump_next = "<c-l>",
                    jump_prev = "<c-h>",
                    stop = "<c-e>",
                },
                snippets = {
                    gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
                    gen_loader.from_lang(),
                },
            }
        end,
    },
    {
        "nvim-mini/mini.surround",
        event = { "BufNewFile", "BufReadPre" },
        keys = {
            { "gs", desc = "Add Surrounding", mode = { "n", "v" } },
            { "ds", desc = "Delete Surrounding" },
            { "cs", desc = "Replace Surrounding" },
        },
        opts = {
            mappings = {
                add = "gs", -- Add surrounding in Normal and Visual modes
                delete = "ds", -- Delete surrounding
                replace = "cs", -- Replace surrounding

                find = "", -- Find surrounding (to the right)
                find_left = "", -- Find surrounding (to the left)
                highlight = "", -- Highlight surrounding
                update_n_lines = "", -- Update `n_lines`
            },
        },
    },
}
