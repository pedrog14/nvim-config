local M = {}

M.default_capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

---@param opts Lspconfig.Opts
M.setup = function(opts)
    vim.diagnostic.config(opts.diagnostic_config)
    vim.api.nvim_create_autocmd("LspAttach", { callback = opts.on_attach })
    require("mason-lspconfig").setup_handlers(opts.handlers)
end

return M
