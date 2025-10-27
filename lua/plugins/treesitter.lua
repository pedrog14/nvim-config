return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = vim.fn.argc(-1) == 0,
        event = { "BufNewFile", "BufWritePre", "BufReadPost", "VeryLazy" },
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        main = "utils.plugins.treesitter",
        opts = {
            auto_install = { enable = true },
            ensure_installed = {
                "c",
                "lua",
                "bash",
                "vim",
                "vimdoc",
                "query",
                "regex",
                "markdown",
                "markdown_inline",
                "html",
                "javascript",
                "latex",
                "norg",
                "scss",
                "svelte",
                "tsx",
                "typst",
                "vue",
            },
            highlight = { enable = true },
            fold = { enable = true },
            indent = { enable = true },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
            max_lines = 3,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        main = "utils.plugins.treesitter.textobjects",
        opts = {
            move = {
                enable = true,
                set_jumps = true,
                keys = {
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                    },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner",
                    },
                },
            },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufNewFile", "BufWritePre", "BufReadPost" },
        opts = {},
    },
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
