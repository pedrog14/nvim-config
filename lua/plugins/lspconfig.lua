return {
    "neovim/nvim-lspconfig",
    dependencies = "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    cmd = { "LspInfo", "LspStart", "LspStop", "LspRestart" },
    main = "utils.plugins.lspconfig",
    ---@module "utils.plugins.lspconfig"
    ---@type lspconfig.opts
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
        diagnostic = {
            severity_sort = true,
            signs = { text = require("utils.icons").diagnostic.signs },
        },
        servers = {
            ["*"] = {
                capabilities = {
                    workspace = {
                        fileOperations = {
                            didRename = true,
                            willRename = true,
                        },
                    },
                },
            },
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        codeLens = { enable = true },
                        hint = {
                            enable = true,
                            paramName = "Disable",
                            semicolon = "Disable",
                            arrayIndex = "Disable",
                        },
                    },
                },
            },
        },
        codelens = { enabled = true },
        inlay_hint = { enabled = true },
        fold = { enabled = true },
    },
}
