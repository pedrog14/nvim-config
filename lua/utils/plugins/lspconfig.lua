---@class utils.plugins.lspconfig
local M = {}

---@param capabilities? lsp.ClientCapabilities
---@return lsp.ClientCapabilities
M.client_capabilities = function(capabilities)
    local has_blink, blink = pcall(require, "blink-cmp")
    return vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        capabilities or {}
    )
end

---@param opts lspconfig.Opts
M.setup = function(opts)
    for server, value in pairs(opts) do
        vim.lsp.config(server, value)
    end
end

return M
