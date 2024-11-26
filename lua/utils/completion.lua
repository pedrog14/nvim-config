local M = {}

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
