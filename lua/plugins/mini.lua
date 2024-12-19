return {
    {
        "echasnovski/mini.ai",
        event = { "BufNewFile", "BufReadPre" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({ -- code block
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
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
        "echasnovski/mini.files",
        lazy = false,
        keys = {
            {
                "<leader>n",
                function()
                    MiniFiles.open(vim.uv.cwd())
                end,
                desc = "Mini-Files Toggle",
            },
        },
        main = "utils.plugins.mini.files",
        opts = function()
            return {
                windows = {
                    border = "rounded",
                },
            }
        end,
    },

    {
        "echasnovski/mini.icons",
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
        "echasnovski/mini.hipatterns",
        event = { "BufNewFile", "BufReadPre" },
        opts = function()
            local hipatterns = require("mini.hipatterns")
            local utils = require("utils").plugins.mini.hipatterns
            return {
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color({ priority = 2000 }),
                    hex_alpha_color = utils.hex_alpha_color({ priority = 2000 }),
                    shorthand = utils.shorthand({ priority = 2000 }),
                },
            }
        end,
    },

    {
        "echasnovski/mini.pairs",
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
        "echasnovski/mini.surround",
        event = { "BufNewFile", "BufReadPre" },
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
