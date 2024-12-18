return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        keys = {
            {
                "<leader>m",
                function()
                    require("mason.ui").open()
                end,
                desc = "Open Mason",
            },
        },
        opts = {
            ui = {
                icons = {
                    package_installed = "󰱒",
                    package_pending = "󰄱",
                    package_uninstalled = "󱋭",
                },
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim",
        lazy = false,
        main = "utils.plugins.mason.lspconfig",
        opts = {
            ensure_installed = {
                "bashls",
                "cssls",
                "clangd",
                "elixirls",
                "emmet_ls",
                "hls",
                "html",
                "lua_ls",
                "pylsp",
                "rust_analyzer",
                "ts_ls",
                "vimls",
            },
        },
    },

    {
        "pedrog14/mason-conform.nvim",
        dependencies = "williamboman/mason.nvim",
        lazy = false,
        main = "utils.plugins.mason.conform",
        opts = {
            ensure_installed = {
                "black",
                "clang-format",
                "fourmolu",
                "prettier",
                "shfmt",
                "stylua",
            },
        },
    },
}
