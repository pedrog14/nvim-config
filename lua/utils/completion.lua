---@class utils.completion
local M = {}

M.exec_keys = function(keys)
    vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
end

---@param client vim.lsp.Client
---@param bufnr integer
M.client_convert = function(client, bufnr)
    local protocol = vim.lsp.protocol

    ---@param item lsp.CompletionItem
    return function(item)
        local converted = {}

        local kind = protocol.CompletionItemKind[item.kind]
        local icons = require("utils").plugins.mini.icons.get("lsp")
        local widths = {
            label = vim.g.completion_width and vim.g.completion_width.label
                or 40,
            detail = vim.g.completion_width and vim.g.completion_width.detail
                or 32,
        }

        converted["kind"] = ("%s %s"):format(icons[kind:lower()], kind)
        for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                converted[key] = vim.fn.strcharpart(item[key], 0, width - 1)
                    .. "…"
            end
        end

        return {
            kind = converted["kind"],
            abbr = converted["label"] or item["label"],
            menu = converted["detail"] or item["detail"],
        }
    end
end

return M
