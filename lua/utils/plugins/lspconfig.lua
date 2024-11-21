local M = {}

M.default_capabilities = function(capabilities)
    return vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), capabilities or {})
end

M.setup = function(opts)
    vim.diagnostic.config(opts.diagnostics)
    require("mason-lspconfig").setup_handlers({
        function(server_name)
            require("lspconfig")[server_name].setup({
                settings = opts.settings[server_name],
                capabilities = opts.capabilities,
                on_attach = opts.on_attach,
            })
        end,
    })
end

return M
