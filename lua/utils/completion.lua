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
M.enable_documentation = function(client, bufnr)
    vim.api.nvim_create_autocmd("CompleteDonePre", {
        buffer = bufnr,
        callback = function()
            vim.g.documentation_win = nil
        end,
    })

    vim.api.nvim_create_autocmd("CompleteChanged", {
        buffer = bufnr,
        callback = function()
            local info = vim.fn.complete_info({ "selected" })
            local completionItem = vim.tbl_get(
                vim.v.completed_item,
                "user_data",
                "nvim",
                "lsp",
                "completion_item"
            )

            client:request(
                "completionItem/resolve",
                completionItem,
                function(err, result)
                    if err then
                        if
                            vim.g.documentation_win
                            and vim.api.nvim_win_is_valid(
                                vim.g.documentation_win.winid or -1
                            )
                        then
                            vim.api.nvim_win_close(
                                vim.g.documentation_win.winid,
                                false
                            )
                            vim.g.documentation_win = nil
                        end
                        return
                    end

                    if not result then
                        return
                    end

                    local win_doc = result.documentation
                            and vim.api.nvim__complete_set(
                                info["selected"],
                                { info = result.documentation.value }
                            )
                        or nil

                    if not win_doc or not win_doc.winid then
                        if
                            vim.g.documentation_win
                            and vim.api.nvim_win_is_valid(
                                vim.g.documentation_win.winid or -1
                            )
                        then
                            vim.api.nvim_win_close(
                                vim.g.documentation_win.winid,
                                false
                            )
                            vim.g.documentation_win = nil
                        end
                        return
                    end

                    vim.wo[win_doc.winid].conceallevel = 2
                    vim.wo[win_doc.winid].concealcursor = "n"
                    vim.treesitter.start(
                        win_doc.bufnr,
                        result.documentation.kind
                    )

                    vim.g.documentation_win = win_doc
                end,
                bufnr
            )
        end,
    })
end

---@param client vim.lsp.Client
---@param bufnr integer
M.client_convert = function(client, bufnr)
    local protocol = vim.lsp.protocol

    return function(item)
        local icons = require("utils.icons").mini("lsp")
        local kind = protocol.CompletionItemKind[item.kind]

        kind = ("%s %s"):format(icons[kind:lower()], kind)

        return {
            kind = kind,
        }
    end
end

return M
