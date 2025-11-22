local M = {}

---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? number
---@param callback function
M.on_supports_method = function(client, method, bufnr, callback)
    if client:supports_method(method, bufnr or vim.api.nvim_get_current_buf()) then
        callback()
    end
end

return M
