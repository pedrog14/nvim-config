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
            },
            highlight = { enable = true },
            folds = { enable = true },
            indent = { enable = true },

            auto_install = true,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        opts = {},
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
            max_lines = 3,
        },
    },
    {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
        opts = {},
    },
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
