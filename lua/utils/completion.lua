local completion = vim.lsp.completion

---@class utils.completion
local M = {}

M.enable = completion.enable

M.trigger = completion.trigger

---@return boolean
M.is_visible = function()
    return vim.fn.pumvisible() ~= 0
end

---@return integer
M.selected = function()
    return vim.fn.complete_info({ "selected" })["selected"]
end

---@param keys string
M.exec_keys = function(keys)
    vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
end

---@return fun(item: lsp.CompletionItem): vim.v.completed_item
M.client_convert = function()
    return function(item)
        local converted = {}

        local kind = vim.tbl_get(vim.lsp.protocol, "CompletionItemKind", item.kind)
        local icon = require("mini.icons").get("lsp", kind:lower())
        converted["kind"] = ("%s %s"):format(icon, kind)

        local widths = {
            label = vim.g.completion_width and vim.g.completion_width.label or 32,
            detail = vim.g.completion_width and vim.g.completion_width.detail or 32,
        }
        for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                converted[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
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
