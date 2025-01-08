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
                    f = ai.gen_spec.treesitter({
                        a = "@function.outer",
                        i = "@function.inner",
                    }), -- function
                    c = ai.gen_spec.treesitter({
                        a = "@class.outer",
                        i = "@class.inner",
                    }), -- class
                    t = {
                        "<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
                        "^<.->().*()</[^/]->$",
                    }, -- tags
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
        "echasnovski/mini.snippets",
        dependencies = "rafamadriz/friendly-snippets",
        lazy = true,
        opts = function()
            local gen_loader = require("mini.snippets").gen_loader

            -- Custom expand: Insert
            local insert = function(snippet)
                return MiniSnippets.default_insert(
                    snippet,
                    { empty_tabstop = "", empty_tabstop_final = "" }
                )
            end

            return {
                expand = { insert = insert },
                snippets = {
                    -- Load custom file with global snippets first (adjust for Windows)
                    gen_loader.from_file(
                        vim.fn.stdpath("config") .. "/snippets/global.json"
                    ),

                    -- Load snippets based on current language by reading files from
                    -- "snippets/" subdirectories from 'runtimepath' directories.
                    gen_loader.from_lang(),
                },
            }
        end,
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
