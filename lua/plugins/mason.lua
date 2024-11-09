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
        lazy = true,
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
}
