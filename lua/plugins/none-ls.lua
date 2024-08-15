return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = "jay-babu/mason-null-ls.nvim",
        opts = function(_, opts)
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            opts.on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({
                        group = augroup,
                        buffer = bufnr,
                    })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end
        end,
    },

    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = "williamboman/mason.nvim",
        cmd = { "NoneLsInstall", "NoneLsUninstall" },
        opts = {
            handlers = {},
        },
    },
}
