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

---@param client? vim.lsp.Client
---@param bufnr? integer
M.format_completion = function(client, bufnr)
    local protocol = vim.lsp.protocol
    local kind_icons = require("utils.icons").mini("lsp")

    vim.api.nvim_create_autocmd("CompleteChanged", {
        buffer = bufnr,
        callback = function()
            local info = vim.fn.complete_info({ "selected" })
            local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")

            if not client then
                return
            end

            client:request(protocol.Methods.completionItem_resolve, completion_item, function(err, result)
                local win_data = vim.g.completion_doc

                if err or not result or not result.documentation then
                    local success, res = pcall(vim.api.nvim_win_is_valid, win_data and win_data.winid)
                    if success and res then
                        vim.api.nvim_win_close(win_data.winid, false)
                    end
                    vim.g.completion_doc = nil
                    return
                end

                local documentation = vim.tbl_get(result, "documentation")

                win_data = vim.api.nvim__complete_set(info["selected"], { info = documentation.value })

                if not win_data.winid or not vim.api.nvim_win_is_valid(win_data.winid) then
                    return
                end

                vim.wo[win_data.winid].conceallevel = 2
                vim.wo[win_data.winid].concealcursor = "n"

                vim.bo[win_data.bufnr].syntax = documentation.kind
                vim.treesitter.start(win_data.bufnr, documentation.kind)

                vim.g.completion_doc = win_data
            end, bufnr)
        end,
    })

    ---@param item lsp.CompletionItem
    return function(item)
        local kind_text = protocol.CompletionItemKind[item.kind]
        return {
            kind = kind_icons[kind_text:lower()] .. kind_text,
        }
    end
end

return M
