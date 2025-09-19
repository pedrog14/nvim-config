return {
    {
        "mason-org/mason.nvim",
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
        main = "utils.plugins.mason",
        ---@module "mason"
        ---@type MasonSettings
        opts = {
            ui = {
                backdrop = 100,
                icons = {
                    package_installed = "󰱒",
                    package_pending = "󰄱",
                    package_uninstalled = "󱋭",
                },
            },
            ensure_installed = {
                -- Formatters
                "autopep8",
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
        "mason-org/mason-lspconfig.nvim",
        dependencies = "mason-org/mason.nvim",
        lazy = false,
        ---@module "mason-lspconfig"
        ---@type MasonLspconfigSettings
        opts = {
            ensure_installed = {
                "bashls",
                "cssls",
                "clangd",
                "hls",
                "html",
                "jdtls",
                "lua_ls",
                "pylsp",
                "rust_analyzer",
                "ts_ls",
                "vimls",
            },
        },
    },
}
