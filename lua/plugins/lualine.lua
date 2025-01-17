return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local lualine_require = require("lualine_require")
        lualine_require.require = require

        local diagnostic_icons = require("utils.icons").diagnostic
        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = { "snacks_dashboard" },
                },
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    { "diagnostics", symbols = diagnostic_icons },
                },
            },
            extensions = { "lazy", "mason", "neo-tree", "quickfix" },
        }
    end,
}
