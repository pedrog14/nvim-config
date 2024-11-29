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
        local formatted = {}

        local widths = {
            label = vim.g.comp_width and vim.g.comp_width.label or 40,
            detail = vim.g.comp_width and vim.g.comp_width.detail or 32,
        }
        for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                formatted[key] = vim.fn.strcharpart(item[key], 0, width - 1)
                    .. "…"
            end
        end

        return {
            abbr = formatted["label"] or item["label"],
            menu = formatted["detail"] or item["detail"],
        }
    end
end

return M
