---@class utils.completion
local M = {}

M.exec_keys = function(keys)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(keys, true, false, true),
        "n",
        true
    )
end

---@param client vim.lsp.Client
---@param bufnr integer
M.client_convert = function(client, bufnr)
    local protocol = vim.lsp.protocol

    ---@param item lsp.CompletionItem
    return function(item)
        return {}
    end
end

return M
