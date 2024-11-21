local M = {}

M.trigger = vim.lsp.completion.trigger

M.enable = vim.lsp.completion.enable

M.is_visible = function()
    return vim.fn.pumvisible() ~= 0
end

M.has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.exec_keys = function(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

M.format_completion = function()
    local protocol = vim.lsp.protocol
    local kind_icons = require("utils.icons").mini("lsp")

    ---@param item lsp.CompletionItem
    return function(item)
        local kind_text = protocol.CompletionItemKind[item.kind]
        return {
            kind = kind_icons[kind_text:lower()] .. kind_text,
        }
    end
end

return M
