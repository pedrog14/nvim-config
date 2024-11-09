return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufNewFile", "BufReadPre", "VeryLazy" },
        lazy = vim.fn.argc(-1) == 0,
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = {
            { "<c-space>", desc = "Increment selection", mode = { "x", "n" } },
            { "<bs>", desc = "Decrement selection", mode = "x" },
        },
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        main = "nvim-treesitter.configs",
        opts = {
            -- Base
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },

            -- Incremental Selection
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<c-space>",
                    node_incremental = "<c-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },

            -- Textobjects
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                    },
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                    },
                },
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufNewFile", "BufReadPre" },
        opts = {
            mode = "cursor",
            max_lines = 3,
            separator = "─",
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = { "BufNewFile", "BufReadPre" },
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = { "BufNewFile", "BufReadPre" },
        main = "utils.plugins.ts-commentstring",
        opts = {
            enable_autocmd = false,
        },
    },

    {
        "windwp/nvim-ts-autotag",
        event = { "BufNewFile", "BufReadPre" },
        opts = {},
    },
}
