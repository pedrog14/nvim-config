---@class utils.icons
local M = {}

-- stylua: ignore

M.diagnostic = {
    ---@type table<vim.diagnostic.Severity, string>
    signs = { "󰅙 ", "󰀨 ", "󰋼 ", "󰋗 " },
    virtual_text = {
        prefix = "●",
    },
}

return M
