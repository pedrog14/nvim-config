local M = {}

---@param item vim.CompletedItem
---@return vim.CompletedItem
M.format_cmp = function(_, item)
    local icons = require("utils.icons").mini("lsp")
    local kind = item.kind:lower()

    if icons[kind] then
        item.kind = ("%s %s"):format(icons[kind], item.kind)
    end

    return item
end

M.setup = function(opts)
    local global = opts.global or {}

    for _, source in ipairs(global.sources) do
        source.group_index = source.group_index or 1
    end

    vim.api.nvim_set_hl(0, "CmpGhostText", {
        link = "Comment",
        default = true,
    })

    local cmp = require("cmp")

    cmp.setup.global(opts.global or {})
    cmp.setup.cmdline(":", opts.cmdline or {})
    cmp.setup.cmdline({ "/", "?" }, opts.search or {})
end

return M
