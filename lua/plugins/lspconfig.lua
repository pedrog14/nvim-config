return {
    "neovim/nvim-lspconfig",
    dependencies = "williamboman/mason-lspconfig.nvim",
    event = { "BufNewFile", "BufReadPre" },
    main = "utils.plugins.lspconfig",
    init = function()
        local severity = vim.diagnostic.severity
        local diagnostic_icons = require("utils").icons.diagnostics
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
            settings = {},
            capabilities = require("utils").plugins.lspconfig.client_capabilities(),
            on_attach = function(client, bufnr)
                local lsp = vim.lsp

                if client:supports_method("textDocument/inlayHint", bufnr) then
                    lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end

                if client:supports_method("textDocument/codeLens", bufnr) then
                    lsp.codelens.refresh({ bufnr = bufnr })

                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = bufnr,
                        callback = lsp.codelens.refresh,
                    })
                end

                -- if client:supports_method("textDocument/completion", bufnr) then
                --     local completion = require("utils").completion
                --
                --     completion.enable(true, client.id, bufnr, {
                --         autotrigger = false,
                --         convert = completion.client_convert(),
                --     })
                --
                --     -- Better completion
                --     vim.keymap.set("i", "<c-n>", function()
                --         if completion.is_visible() then
                --             completion.exec_keys("<c-n>")
                --         else
                --             completion.trigger()
                --         end
                --     end, {
                --         desc = "Open or Select Next Completion",
                --         buffer = bufnr,
                --     })
                -- end
            end,
        }
    end,
}
