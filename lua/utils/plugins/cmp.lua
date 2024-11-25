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

---@param opts cmp.Opts
M.setup = function(opts)
    local global, cmdline, search = opts.global or {}, opts.cmdline or {}, opts.search or {}
    global.sources = global.sources or {}

    for _, source in ipairs(global.sources) do
        source.group_index = source.group_index or 1
    end

    local ghost_text = global.experimental and global.experimental.ghost_text
    if ghost_text and ghost_text.hl_group then
        vim.api.nvim_set_hl(0, ghost_text.hl_group, {
            link = "Comment",
            default = true,
        })
    end

    local cmp = require("cmp")

    cmp.setup.global(global)
    cmp.setup.cmdline(":", cmdline)
    cmp.setup.cmdline({ "/", "?" }, search)
end

return M
