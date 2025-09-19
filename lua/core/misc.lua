local severity = vim.diagnostic.severity
local diagnostic_icons = require("utils.icons").diagnostic

local severity_icon = diagnostic_icons.signs
local prefix_icon = diagnostic_icons.virtual_text.prefix

vim.diagnostic.config({
    severity_sort = true,
    signs = {
        -- stylua: ignore
        text = {
            [severity.ERROR] = severity_icon.error,
            [severity.WARN]  = severity_icon.warn,
            [severity.INFO]  = severity_icon.info,
            [severity.HINT]  = severity_icon.hint,
        },
    },
    virtual_text = { prefix = prefix_icon },
})

local cmd = vim.cmd

cmd.colorscheme("gruvbox")
