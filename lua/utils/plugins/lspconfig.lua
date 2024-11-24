---@class lspconfig.Opts
---@field diagnostics? vim.diagnostic.Opts
---@field settings? table<string, table>
---@field capabilities? lsp.ClientCapabilities
---@field on_attach? fun(client: vim.lsp.Client, bufnr: integer)

local M = {}

---@param capabilities? lsp.ClientCapabilities
---@return lsp.ClientCapabilities
M.default_capabilities = function(capabilities)
    local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
    return vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp.default_capabilities() or {},
        capabilities or {}
    )
end

---@param opts lspconfig.Opts
M.setup = function(opts)
    opts.settings = opts.settings or {}
    vim.diagnostic.config(opts.diagnostics)
    require("mason-lspconfig").setup_handlers({
        function(server_name)
            local settings, capabilities, on_attach = opts.settings[server_name], opts.capabilities, opts.on_attach
            require("lspconfig")[server_name].setup({
                settings = settings,
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end,
    })
end

return M
