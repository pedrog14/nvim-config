return {
    "neovim/nvim-lspconfig",
    dependencies = "williamboman/mason-lspconfig.nvim",
    event = { "BufNewFile", "BufReadPre" },
    main = "utils.plugins.lspconfig",
    init = function()
        local severity = vim.diagnostic.severity
        local diagnostic_icons = require("utils.icons").diagnostic
        vim.diagnostic.config({
            signs = {
                text = {
                    [severity.E] = diagnostic_icons.error,
                    [severity.W] = diagnostic_icons.warn,
                    [severity.I] = diagnostic_icons.info,
                    [severity.N] = diagnostic_icons.hint,
                },
            },
            virtual_text = {
                prefix = "●",
            },
            severity_sort = true,
        })
    end,
    opts = function()
        ---@type lspconfig.Opts
        return {
            capabilities = require("utils.plugins.lspconfig").client_capabilities(),
            on_attach = function(client, bufnr)
                local lsp = vim.lsp

                client.supports_method(
                    "textDocument/inlayHint",
                    { bufnr = bufnr }
                )

                if
                    client.supports_method(
                        "textDocument/inlayHint",
                        { bufnr = bufnr }
                    )
                then
                    lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end

                if
                    client.supports_method(
                        "textDocument/codeLens",
                        { bufnr = bufnr }
                    )
                then
                    lsp.codelens.refresh({ bufnr = bufnr })

                    vim.api.nvim_create_autocmd(
                        { "BufEnter", "CursorHold", "InsertLeave" },
                        { buffer = bufnr, callback = lsp.codelens.refresh }
                    )
                end
            end,
            settings = {
                lua_ls = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                    },
                },
            },
        }
    end,
}
