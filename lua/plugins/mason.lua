return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        main = "utils.plugins.mason",
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
            ensure_installed = {
                -- Formatters
                "black",
                "clang-format",
                "fourmolu",
                "prettier",
                "shfmt",
                "stylua",
            },
        },
        opts_extend = { "ensure_installed" },
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
}
