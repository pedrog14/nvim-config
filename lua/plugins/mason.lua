return {
    {
        "williamboman/mason.nvim",
        lazy = false,
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
        opts = function(_, opts)
            opts.ensure_installed = {
                "lua_ls",
                "bashls",
                "cssls",
                "clangd",
                "emmet_ls",
                "hls",
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
        "pedrog14/mason-conform.nvim",
        dependencies = "williamboman/mason.nvim",
        lazy = false,
        opts = function(_, opts)
            opts.ensure_installed = {
                "black",
                "clang-format",
                "fourmolu",
                "gofumpt",
                "prettier",
                "shfmt",
                "stylua",
            }
        end,
    },
}
