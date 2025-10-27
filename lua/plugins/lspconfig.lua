return {
    "neovim/nvim-lspconfig",
    dependencies = "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    main = "utils.plugins.lspconfig",
    opts = function()
        local diagnostic_icons = require("utils.icons").diagnostic
        local severity = vim.diagnostic.severity

        local severity_icon = diagnostic_icons.signs

        ---@module "utils.plugins.lspconfig"
        ---@type lspconfig.opts
        return {
            diagnostic = {
                severity_sort = true,
                signs = {
                    text = {
                        [severity.ERROR] = severity_icon.error,
                        [severity.WARN] = severity_icon.warn,
                        [severity.INFO] = severity_icon.info,
                        [severity.HINT] = severity_icon.hint,
                    },
                },
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
                            hint = { enable = true },
                        },
                    },
                },
            },
            codelens = { enabled = true },
            inlay_hint = { enabled = true },
            fold = { enabled = true },
        }
    end,
}
