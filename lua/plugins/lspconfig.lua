return {
    {
        "neovim/nvim-lspconfig",
        dependencies = "williamboman/mason-lspconfig.nvim",
        config = function()
            -- Diagnostic icons
            local icons = require("config").icons.diagnostics

            -- Diagnostic config
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = icons.Error,
                        [vim.diagnostic.severity.WARN] = icons.Warn,
                        [vim.diagnostic.severity.INFO] = icons.Info,
                        [vim.diagnostic.severity.HINT] = icons.Hint,
                    },
                },
                virtual_text = {
                    prefix = "●",
                },
                severity_sort = true,
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim",
        lazy = true,
        opts = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local settings = {
                ["pylsp"] = {
                    pylsp = {
                        plugins = {
                            jedi = {
                                environment = "/usr/bin/python",
                            },
                        },
                    },
                },
            }

            local handlers = {
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        settings = settings[server_name],
                    })
                end,
            }

            return {
                handlers = handlers,
            }
        end,
    },
}
