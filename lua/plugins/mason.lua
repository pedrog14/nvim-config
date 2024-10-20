return {
    {
        "williamboman/mason.nvim",
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
        opts = function(_, opts)
            opts.ensure_installed = {
                "lua_ls",
                "bashls",
                "cssls",
                "clangd",
                "emmet_ls",
                "html",
                "ts_ls",
                "pylsp",
                "gopls",
                "rust_analyzer",
                "vimls",
            }
        end,
    },

    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = "williamboman/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = {
                "black",
                "clang-format",
                "gofumpt",
                "prettier",
                "shfmt",
                "stylua",
            }
        end,
    },
}
