local M = {}

M.default_capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

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
