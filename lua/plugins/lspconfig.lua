return {
    "neovim/nvim-lspconfig",
    dependencies = "williamboman/mason-lspconfig.nvim",
    event = { "BufNewFile", "BufReadPre" },
    init = function()
        local severity = vim.diagnostic.severity
        local diagnostic_icons = require("utils.icons").diagnostic
        vim.diagnostic.config({
            signs = {
                text = {
                    [severity.ERROR] = diagnostic_icons.error,
                    [severity.WARN] = diagnostic_icons.warn,
                    [severity.INFO] = diagnostic_icons.info,
                    [severity.HINT] = diagnostic_icons.hint,
                },
            },
            virtual_lines = {
                current_line = true,
            },
            virtual_text = {
                prefix = "●",
            },
            severity_sort = true,
        })
    end,
    main = "utils.plugins.lspconfig",
    opts = { --[[@type lspconfig.Opts]]
        capabilities = {
            ["*"] = require("utils.plugins.lspconfig").client_capabilities(),
        },
        -- on_attach = {
        --     ["*"] = function(client, bufnr) end,
        -- },
        settings = {
            lua_ls = {
                Lua = { workspace = { checkThirdParty = false } },
            },
        },
    },
}
